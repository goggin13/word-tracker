class DefinitionsController < ApplicationController
  before_action :set_definition, only: [:show, :edit, :update, :destroy]

  # GET /definitions
  def index
    @definitions = Definition.all
    respond_to do |format|
      format.html
      format.json { render :json => @definitions }
    end
  end

  # GET /definitions/1
  def show
  end

  # GET /definitions/new
  def new
    @definition = Definition.new
  end

  # GET /definitions/1/edit
  def edit
  end

  # POST /definitions
  def create
    definitions = Definition.find_or_create_for_word(params[:definition][:word])
    redirect_to definitions[0], notice: "Definition was successfully created."
  end

  # PATCH/PUT /definitions/1
  def update
    if @definition.update(definition_params)
      redirect_to @definition, notice: 'Definition was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /definitions/1
  def destroy
    @definition.destroy
    redirect_to definitions_url, notice: 'Definition was successfully destroyed.'
  end

  def define
    definitions = Definition.find_or_create_for_word(params[:word])
    render :json => {
      word: params[:word],
      definitions: definitions.map(&:text)
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_definition
      @definition = Definition.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def definition_params
      params.require(:definition).permit(:word, :text, :example)
    end
end
