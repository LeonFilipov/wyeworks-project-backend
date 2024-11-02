class UniversitiesController < ApplicationController
  before_action :set_university, only: [ :show, :careers ]

  # GET /universities
  def index
    @universities = University.all
    render json: @universities, status: :ok
  end

  # GET /universities/:id
  def show
    render json: @university, status: :ok
  end

# POST /universities
=begin
  def create
    @university = University.new(university_params)
    if @university.save
      render json: @university, status: :created
    else
      render json: @university.errors, status: :unprocessable_entity
    end
  end
=end

  # GET /universities/:id/careers
  def careers
    @careers = @university.careers.select(:id, :name)
    render json: @careers, status: :ok
  end

  private

  # Method to get a university by ID
  def set_university
    @university = University.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: I18n.t("error.universities.not_found") }, status: :not_found
  end

  def university_params
    params.require(:university).permit(:name, :location)
  end
end
