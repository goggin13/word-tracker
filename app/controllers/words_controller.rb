class WordsController < ApplicationController
  before_action :set_word, only: [:show, :destroy]
  before_action :authenticate!, only: [:create, :destroy]

  # GET /words
  def index
    if params[:user_id].present?
      @words = Word.where(user_id: params[:user_id])
      @user = User.find(params[:user_id])
    elsif signed_in?
      @words = current_user.words
      @user = current_user
    else
      @words = User.default_user.words
      @user = User.default_user
    end

    respond_to do |format|
      format.html
      format.json { render json: @words }
    end
  end

  # GET /words/1
  def show
  end

  # GET /words/new
  def new
    @word = Word.new
  end

  # POST /words
  def create
    @word = Word.find_or_create_with_definitions(current_user, params[:word])

    if @word
      respond_to do |format|
        format.html { redirect_to @word, notice: "#{@word.text} was successfully created." }
        format.json { render json: @word }
      end
    else
      error = "No definition found for '#{params[:word]}'"
      respond_to do |format|
        format.html { redirect_to new_word_path, alert: error }
        format.json { render json: { errors: [error] }, status: 422 }
      end
    end
  end

  # DELETE /words/1
  def destroy
    @word.destroy
    redirect_to words_url, notice: "#{@word.text} was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def word_params
      params.require(:word).permit(:text)
    end
end
