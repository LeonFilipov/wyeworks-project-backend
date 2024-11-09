class MeetsController < ApplicationController
    before_action :set_meet, only: [ :update, :show, :add_interest, :remove_interest, :cancel_meet ]

    def index
      meets = Meet.all
      if params[:topic_id].present?
        meets = meets.joins(availability_tutor: :topic)
                     .where(topics: { id: params[:topic_id] })
      end

      if params[:status].present?
        meets = meets.where(status: params[:status])
      end

      if params[:participant_id].present?
        meets = meets.joins(:participants).where(participants: { user_id: params[:participant_id] })
      end

      if params[:tutor_id].present?
        meets = meets.joins(availability_tutor: :user)
                     .where(users: { id: params[:tutor_id] })
      end
      render json: meets.select(:id, :date_time, :status, :link, :count_interesteds), status: :ok
    end

    # GET /meets/:id
    def show
      render json: {
        date: @meet.date_time,
        status: @meet.status,
        link: @meet.link,
        participant: @meet.participants.exists?(user_id: @current_user.first.id),
        topic: {
          id: @meet.availability_tutor.topic.id,
          name: @meet.availability_tutor.topic.name,
          proposed: @meet.availability_tutor.user.id == @current_user.first.id
        },
        tutor: {
          id: @meet.availability_tutor.user.id,
          name: @meet.availability_tutor.user.name,
          email: @meet.availability_tutor.user.email.presence
        },
        participants: @meet.participants.map do |participant|
          {
            id: participant.user.id,
            name: participant.user.name
          }.tap do |participant_data|
            participant_data[:email] = participant.user.email if @meet.availability_tutor.topic.show_email
          end
        end
      }, status: :ok
    end


    # PATCH/PUT /meets/:id
    def update
      @availability_tutor = AvailabilityTutor.find(@meet.availability_tutor_id)

      # Verificar que el usuario es el tutor del tema
      unless @current_user.first.id == @availability_tutor.user_id
        render json: { error: I18n.t("error.users.not_allowed") }, status: :unauthorized and return
      end

      if @meet.status == "cancelled" || @meet.status == "completed"
        render json: { error: I18n.t("error.meets.already_status", status: @meet.status) }, status: :bad_request and return
      end

      params_formatted = {
        date_time: params[:meet][:date].present? && @meet.date_time.nil? ? params[:meet][:date] : @meet.date_time,
        link: params[:meet][:link].present? ? params[:meet][:link] : @meet.link
      }

      @meet.assign_attributes(params_formatted) # Permitir modificar otros campos permitidos
      # Actualizar la información de la reunión
      if params[:meet][:date].present? && @meet.status == "pending"
        @meet.status = "confirmed" # Confirmar la reunión si se modifica la fecha
        @meet.date_time = params[:meet][:date]
      end

      
      if @meet.save!
        MeetsService.create_pending_meet({ availability_tutor_id: @availability_tutor.id, link: @availability_tutor.topic.link, status: "pending" })
        UserMailer.meet_confirmada_email(@meet.id, @availability_tutor.user_id, @availability_tutor.topic_id).deliver_now # Enviar correo de confirmación
        render json: { message: I18n.t("success.meets.updated") }, status: :ok
      else
        render json: { error: @meet.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    end

    # POST /meets/:id/interesteds
    def add_interest
      if @meet.availability_tutor.user_id == @current_user.first.id
        render json: { error: I18n.t("error.meets.tutor_interested") }, status: :bad_request
        return
      end
      if @meet.status == "cancelled" || @meet.status == "completed"
        render json: { error: I18n.t("error.meets.already_status", status: @meet.status) }, status: :bad_request
      else
        if Participant.find_by(user_id: @current_user.first.id, meet_id: @meet.id)
          render json: { error: I18n.t("error.meets.already_interested") }, status: :bad_request
          return
        end
        participant = Participant.new(user_id: @current_user.first.id, meet_id: @meet.id)
        begin
          if participant.save!
            @meet.count_interesteds += 1
            @meet.save!
            Interested.find_or_create_by!(user_id: @current_user.first.id, availability_tutor_id: @meet.availability_tutor_id)
            render json: { message: I18n.t("success.meets.interested") }, status: :ok
          end
        rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
          render json: { error: e.message }, status: :bad_request
        end
      end
    end

    # DELETE /meets/:id/interesteds
    def remove_interest
      if @meet.status == "cancelled" || @meet.status == "completed"
        render json: { error: I18n.t("error.meets.already_status", status: @meet.status) }, status: :bad_request
      else
        participant = Participant.find_by(user_id: @current_user.first.id, meet_id: @meet.id)
        if participant.nil?
          render json: { error: I18n.t("error.participants.not_found") }, status: :not_found
        else
          participant.destroy
          @meet.count_interesteds -= 1
          @meet.save!
          meets = Meet.where(availability_tutor_id: @meet.availability_tutor_id)
          if Participant.where(user_id: @current_user.first.id, meet_id: meets.pluck(:id)).empty?
            interested = Interested.find_by(user_id: @current_user.first.id, availability_tutor_id: @meet.availability_tutor_id)
            interested.destroy
          end
          render json: { message: I18n.t("success.meets.not_interested") }, status: :ok
        end
      end
    end

    # Patch /cancel_meet/:id
    def cancel_meet
      @availability_tutor = AvailabilityTutor.find(@meet.availability_tutor_id)
      # Verificar que el usuario es el tutor del tema
      unless @current_user.first.id == @availability_tutor.user_id
        render json: { error: I18n.t("error.users.not_allowed") }, status: :unauthorized and return
      end

      # Verificar el estado de la reunión
      if @meet.status != "confirmed"
        render json: { error: I18n.t("error.meets.cant_cancel", status: @meet.status) }, status: :bad_request and return
      end

      @meet.status = "cancelled"

      if @meet.save
        topic = Topic.find(@availability_tutor.topic_id)
        MeetsService.create_pending_meet({ availability_tutor_id: @availability_tutor.id, link: topic.link, status: "pending" })
        participants = MeetsService.new(@meet).get_participants_and_topic
        participants.each do |participant|
          UserMailer.meet_cancelada_email(@current_user, participant).deliver_now
        end
        render json: { message: I18n.t("success.meets.cancelled") }, status: :ok
      else
        render json: { error: @meet.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    end

    private
      def set_meet
        @meet = Meet.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t("error.meets.not_found") }, status: :not_found
      end

      def meet_params
        params.require(:meet).permit(:date_time, :link)
      end
end
