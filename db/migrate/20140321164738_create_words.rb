class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :text

      t.timestamps
    end

    add_column :definitions, :word_id, :integer

    sql = <<-SQL
      insert into words (text) select distinct(word) from definitions;
      update words set created_at = now(), updated_at = now();
      update definitions set word_id = (select id from words where text = word);
    SQL
    ActiveRecord::Base.connection.execute(sql)

    remove_column :definitions, :word, :string
  end
end
