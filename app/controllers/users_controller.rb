class UsersController < ApplicationController
    # GET /users
    def index
      @users = User.all
      render json: @users
    end
  
    # GET /users/1
    def show
      @user = User.find(params[:id])
      render json: @user
    end
  
    # GET /users/new
    def new
      @user = User.new
      render json: @user
    end
  
    # POST /users
    def create
      @user = User.new(user_params)
      if @user.save
        render json: @user, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end
  
    # GET /users/1/edit
    def edit
      @user = User.find(params[:id])
      render json: @user
    end
  
    # PATCH/PUT /users/1
    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        render json: @user, status: :ok
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /users/1
    def destroy
      @user = User.find(params[:id])
      @user.destroy
      head :no_content
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
  end
  