class AvailabilityTutorsController < ApplicationController
  # GET /universities/:university_id/subjects/:subject_id/topics/:topic_id/tutor_availability

  # # POST tutor_availability/:id/intersteds
  # def add_interest
  #   @availability = AvailabilityTutor.find(params[:id])
  #   debug_messages = []  # Array para almacenar mensajes de depuración

  #   # Verificar si el usuario ya expresó interés en una meet actual en estado 'pending'
  #   pending_meet = @availability.meets.find_by(status: "pending")
  #   debug_messages << "Found pending meet: #{pending_meet.present?}"

  #   if pending_meet
  #     # Verificar si el usuario ya está interesado en la meet actual en estado 'pending'
  #     pending_meet_interest = pending_meet.users.exists?(id: @current_user.first.id)
  #     debug_messages << "User interested in current pending meet: #{pending_meet_interest}"

  #     if pending_meet_interest
  #       render json: { error: I18n.t("error.meets.already_interested"), debug: debug_messages }, status: :unprocessable_entity
  #       return
  #     end
  #   end

  #   # Verificar si el usuario ya expresó interés en esta disponibilidad
  #   existing_interest = Interested.find_by(user: @current_user.first, availability_tutor: @availability)
  #   debug_messages << "User has existing interest: #{existing_interest.present?}"

  #   unless existing_interest
  #     Interested.create!(user: @current_user.first, availability_tutor: @availability)
  #     debug_messages << "User's interest added to availability tutor."
  #   end

  #   # Verificar si ya existe una reunión en estado 'pending'
  #   pending_meet = @availability.meets.find_by(status: "pending")

  #   if pending_meet.nil?
  #     @meet = @availability.meets.new(
  #       description: "Meeting for #{@availability.description}",
  #       link: "https://meeting-link.com",
  #       mode: "virtual",
  #       status: "pending",
  #       date_time: nil,
  #       count_interesteds: 1
  #     )

  #     if @meet.save
  #       Participant.create!(meet: @meet, user: @current_user.first)
  #       debug_messages << "New meet created successfully, and user added as participant."
  #       render json: { message: [ I18n.t("success.participants.created"), I18n.t("success.meets.created") ], meet: @meet, debug: debug_messages }, status: :created
  #     else
  #       debug_messages << "Failed to create meet: #{@meet.errors.full_messages.join(', ')}"
  #       render json: { message: [ I18n.t("success.participants.created"), I18n.t("errors.meets.not_created") ], errors: @meet.errors.full_messages, debug: debug_messages }, status: :unprocessable_entity
  #     end
  #   else
  #     pending_meet.increment!(:count_interesteds)
  #     debug_messages << "Incremented count_interesteds for existing meet."

  #     unless pending_meet.participants.exists?(user_id: @current_user.first.id)
  #       Participant.create!(meet: pending_meet, user: @current_user.first)
  #       debug_messages << "User added as participant to existing pending meet."
  #     end

  #     render json: { message: [ I18n.t("success.participants.created"), I18n.t("success.meets.updated") ], meet: pending_meet, debug: debug_messages }, status: :ok
  #   end
  # end

  # PATCH /meets/:id
  def update_meet
    @meet = Meet.find(params[:id])

    if @meet.update(date_time: params[:date_time])
      render json: { message: I18n.t("success.meets.updated"), meet: @meet }, status: :ok
    else
      render json: { errors: @meet.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
