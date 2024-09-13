class TagsController < ApplicationController
    before_action :set_tag, only: [ :show, :edit, :update, :destroy ]

    # GET /tags
    def index
      @tags = Tag.all
    end

    # GET /tags/:id
    def show
    end

    # GET /tags/new
    def new
      @tag = Tag.new
    end

    # POST /tags
    def create
      @tag = Tag.new(tag_params)
      if @tag.save
        redirect_to @tag, notice: "Tag was successfully created."
      else
        render :new
      end
    end

    # GET /tags/:id/edit
    def edit
    end

    # PATCH/PUT /tags/:id
    def update
      if @tag.update(tag_params)
        redirect_to @tag, notice: "Tag was successfully updated."
      else
        render :edit
      end
    end

    # DELETE /tags/:id
    def destroy
      @tag.destroy
      redirect_to tags_url, notice: "Tag was successfully destroyed."
    end

    private

    # Método para obtener un tag por ID
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Solo permitir parámetros permitidos
    def tag_params
      params.require(:tag).permit(:name)
    end
end
