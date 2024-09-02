class TutorsController < ApplicationController
    def index
      @tutors = Tutor.all
    end
  
    def show
      @tutor = Tutor.find(params[:id])
    end
  
    def new
      @tutor = Tutor.new
    end
  
    def create
      @tutor = Tutor.new(tutor_params)
      if @tutor.save
        redirect_to @tutor, notice: 'Tutor was successfully created.'
      else
        render :new
      end
    end
  
    def edit
      @tutor = Tutor.find(params[:id])
    end
  
    def update
      @tutor = Tutor.find(params[:id])
      if @tutor.update(tutor_params)
        redirect_to @tutor, notice: 'Tutor was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @tutor = Tutor.find(params[:id])
      @tutor.destroy
      redirect_to tutors_url, notice: 'Tutor was successfully destroyed.'
    end
  
    private
  
    def tutor_params
      params.require(:tutor).permit(:name, :subject)
    end
  end
  