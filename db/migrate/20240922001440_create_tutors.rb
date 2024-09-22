class CreateTutors < ActiveRecord::Migration[7.2]
  def change
    create_table :tutors do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid # si la columna es de tipo UUID
      t.integer :ranking
      t.integer :amount_given_lessons
      t.integer :amount_given_topics
      t.integer :amount_attended_students

      t.timestamps
    end
  end
end
