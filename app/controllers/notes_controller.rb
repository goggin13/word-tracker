class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]
  before_action :authenticate!, only: [:new, :update, :destroy, :create, :edit]

  # GET /notes
  def index
    @notes = Note.all
  end

  def quotes
    @notes = Tag::QUOTE.notes
  end

  # GET /notes/1
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  def create
    @note = Note.new(note_params.merge(:user_id => current_user.id))
    @note.tags += tags_from_params

    if @note.save
      redirect_to @note, notice: 'Note was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /notes/1
  def update
    if @note.update(note_params)
      @note.tags.destroy_all
      @note.tags += tags_from_params
      @note.save!
      redirect_to @note, notice: 'Note was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /notes/1
  def destroy
    @note.destroy
    redirect_to notes_url, notice: 'Note was successfully destroyed.'
  end

  private
    def tags_from_params
      (params[:note][:tags] || "").split(" ").map do |name|
        Tag.find_or_create_by(name: name)
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def note_params
      params.require(:note).permit(:front, :back)
    end
end
