class CreateTopics < ActiveRecord::Migration[7.2]
  def change
    create_table :topics do |t|
      t.string :name
      t.text :asset

      t.timestamps
    end
  end
end
