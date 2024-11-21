class UserMailer < ApplicationMailer
    default from: email_address_with_name("studycirclewye@gmail.com", "StudyCircle")

    def welcome_email_no_AR(user)
        @current_user = user
        mail(
            to: @current_user.email,
            subject: "Bienvenido a StudyCircle"
        )
    end

    def welcome_email(user)
        @current_user = user
        mail(
            to: email_address_with_name(@current_user.first.email, @current_user.first.name),
            subject: "Bienvenido a StudyCircle"
        )
    end

    def meet_confirmada_email(id, user_id, topic_id)
        @meet = Meet.find(id)
        @tutor = User.find(user_id)
        @topic = Topic.find(topic_id)
        @meet.participants.each do |participant|
            @participant = participant
            mail(
                to: email_address_with_name(participant.user.email, participant.user.name),
                subject: "Reunión confirmada"
            )
        end
    end

    def meet_cancelada_email(user, participant)
        @participant = participant
        @current_user = user
        mail(
            to: email_address_with_name(@participant.participant_email, @participant.participant_name),
            subject: "Reunión cancelada"
        )
    end

    def topic_eliminado_email(user, participant)
        @participant = participant
        @current_user = user
        mail(
            to: email_address_with_name(@participant.participant_email, @participant.participant_name),
            subject: "Tema eliminado"
        )
    end
end
