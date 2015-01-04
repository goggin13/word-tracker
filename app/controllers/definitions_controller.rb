class DefinitionsController < ApplicationController
  before_filter :_set_word
  before_action :set_definition, only: [:edit, :update, :destroy]
  before_action :authenticate!, only: [:update, :destroy]

  # GET /definitions/1/edit
  def edit
  end

  # PATCH/PUT /definitions/1
  def update
    if @definition.update(definition_params)
      redirect_to word_path(@word), notice: 'Definition was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /definitions/1
  def destroy
    @definition.destroy
    redirect_to word_path(@word), notice: 'Definition was successfully destroyed.'
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
