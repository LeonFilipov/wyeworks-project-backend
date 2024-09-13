class SubjectsController < ApplicationController
    before_action :set_subject, only: [:show, :edit, :update, :destroy]
  
    # GET /subjects
    def index
      @subjects = Subject.all
    end
  
    # GET /subjects/:id
    def show
    end
  
    # GET /subjects/new
    def new
      @subject = Subject.new
    end
  
    # POST /subjects
    def create
      @subject = Subject.new(subject_params)
      if @subject.save
        redirect_to @subject, notice: 'Subject was successfully created.'
      else
        render :new
      end
    end
  
    # GET /subjects/:id/edit
    def edit
    end
  
    # PATCH/PUT /subjects/:id
    def update
      if @subject.update(subject_params)
        redirect_to @subject, notice: 'Subject was successfully updated.'
      else
        render :edit
      end
    end
  
    # DELETE /subjects/:id
    def destroy
      @subject.destroy
      redirect_to subjects_url, notice: 'Subject was successfully destroyed.'
    end
  
    private
  
    # Método para obtener un subject por ID
    def set_subject
      @subject = Subject.find(params[:id])
    end
  
    # Solo permitir parámetros permitidos
    def subject_params
      params.require(:subject).permit(:name)
    end
  end
  