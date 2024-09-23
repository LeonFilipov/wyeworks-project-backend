class CreateAvailabilityTutors < ActiveRecord::Migration[7.2]
  def change
    create_table :availability_tutors do |t|
      t.references :user, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true
      t.string :description
      t.datetime :tentative_date_from
      t.datetime :tentative_date_to
      t.datetime :effective_date
      t.string :link
      t.string :form

      t.timestamps
    end
  end
end
