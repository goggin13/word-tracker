class CreateDefinitions < ActiveRecord::Migration
  def change
    create_table :definitions do |t|
      t.string :word
      t.text :text
      t.text :example

      t.timestamps
    end
  end
end
