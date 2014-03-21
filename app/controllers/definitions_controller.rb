class DefinitionsController < ApplicationController
  before_filter :_set_word
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
    @definition = Definition.new(word: @word)
  end

  # GET /definitions/1/edit
  def edit
  end

  # POST /definitions
  def create
    @definition = @word.definitions.build(definition_params)

    if @definition.save
      redirect_to word_definition_path(@word, @definition), notice: 'Definition was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /definitions/1
  def update
    if @definition.update(definition_params)
      redirect_to word_definition_path(@word, @definition), notice: 'Definition was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /definitions/1
  def destroy
    @definition.destroy
    redirect_to word_definitions_url(@word), notice: 'Definition was successfully destroyed.'
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

    def _set_word
      @word = Word.find(params[:word_id])
    end
end
