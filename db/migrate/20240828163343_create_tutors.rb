class CreateTutors < ActiveRecord::Migration[7.2]
  def change
    create_table :tutors do |t|
      t.string :name
      t.string :subject

      t.timestamps
    end
  end
end
