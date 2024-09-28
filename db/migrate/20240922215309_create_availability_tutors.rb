class CreateAvailabilityTutors < ActiveRecord::Migration[7.2]
  def change
    create_table :availability_tutors do |t|
      t.references :user, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true
      t.string :description
      t.datetime :date_from
      t.datetime :date_to
      t.string :link

      t.timestamps
    end
  end
end
