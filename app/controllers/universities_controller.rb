class UniversitiesController < ApplicationController
    before_action :set_university, only: [:show, :edit, :update, :destroy]
  
    # GET /universities
    def index
      @universities = University.all
    end
  
    # GET /universities/:id
    def show
    end
  
    # GET /universities/new
    def new
      @university = University.new
    end
  
    # POST /universities
    def create
      @university = University.new(university_params)
      if @university.save
        redirect_to @university, notice: 'University was successfully created.'
      else
        render :new
      end
    end
  
    # GET /universities/:id/edit
    def edit
    end
  
    # PATCH/PUT /universities/:id
    def update
      if @university.update(university_params)
        redirect_to @university, notice: 'University was successfully updated.'
      else
        render :edit
      end
    end
  
    # DELETE /universities/:id
    def destroy
      @university.destroy
      redirect_to universities_url, notice: 'University was successfully destroyed.'
    end
  
    private
  
    # Método para obtener una universidad por ID
    def set_university
      @university = University.find(params[:id])
    end
  
    # Solo permitir parámetros permitidos
    def university_params
      params.require(:university).permit(:name, :location)
    end
  end
  