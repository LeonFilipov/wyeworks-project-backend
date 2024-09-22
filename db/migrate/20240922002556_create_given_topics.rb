class CreateGivenTopics < ActiveRecord::Migration[7.2]
  def change
    create_table :given_topics do |t|
      t.references :tutor, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
