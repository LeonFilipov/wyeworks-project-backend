class SubjectsController < ApplicationController

 # GET /subjects
  # Lists all subjects based on optional query parameters
  def index
    if params[:self].present? && params[:self] == "true" && current_user.career.present?
      @subjects = current_user.career.subjects
    elsif params[:career_id].present?
      career = Career.find_by(id: params[:career_id])
      if career
        @subjects = career.subjects
      else
        render json: { error: I18n.t("error.careers.not_found") }, status: :not_found and return
      end
    else
      @subjects = Subject.all
    end

    render json: @subjects.select(:id, :name), status: :ok
  end

  private

  # Permit only the allowed parameters
  def subject_params
    params.require(:subject).permit(:name)
  end
end
