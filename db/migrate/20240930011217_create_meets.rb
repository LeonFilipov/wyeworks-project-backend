class CreateMeets < ActiveRecord::Migration[7.2]
  def change
    create_table :meets do |t|
      t.datetime :date_time
      t.string :description
      t.string :link
      t.string :mode
      t.string :status
      t.references :availability_tutor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
