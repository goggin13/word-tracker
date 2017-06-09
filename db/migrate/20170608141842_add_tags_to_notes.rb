class AddTagsToNotes < ActiveRecord::Migration
  def change
    create_table :notes_tags do |t|
      t.integer :tag_id, :null => false
      t.integer :note_id, :null => false
    end
  end
end
