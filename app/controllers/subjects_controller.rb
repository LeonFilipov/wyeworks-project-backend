class SubjectsController < ApplicationController
  before_action :set_university
  before_action :set_subject, only: [:show, :update, :destroy]

  # GET /universities/:university_id/subjects
  def index
    @subjects = @university.subjects
    render json: @subjects, status: :ok
  end

  # GET /universities/:university_id/subjects/:id
  def show
    render json: @subject, status: :ok
  end

  # POST /universities/:university_id/subjects
  def create
    @subject = @university.subjects.build(subject_params)
    
    if @subject.save
      render json: @subject, status: :created
    else
      render json: @subject.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /universities/:university_id/subjects/:id
  def update
    if @subject.update(subject_params)
      render json: @subject, status: :ok
    else
      render json: @subject.errors, status: :unprocessable_entity
    end
  end

  # DELETE /universities/:university_id/subjects/:id
  def destroy
    @subject.destroy
    head :no_content  # 204 No Content
  end

  private

  # Set the university based on university_id from the URL
  def set_university
    @university = University.find(params[:university_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "University not found" }, status: :not_found
  end

  # Set the subject within the scope of the university
  def set_subject
    @subject = @university.subjects.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Subject not found" }, status: :not_found
  end

  # Permit only the allowed parameters
  def subject_params
    params.require(:subject).permit(:name)
  end
end
