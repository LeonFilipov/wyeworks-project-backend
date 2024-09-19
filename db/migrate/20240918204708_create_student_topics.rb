class CreateStudentTopics < ActiveRecord::Migration[7.2]
  def change
    create_table :student_topics do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
