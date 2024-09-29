class CreateTentatives < ActiveRecord::Migration[7.2]
  def change
    create_table :tentatives do |t|
      t.string :day
      t.datetime :schedule_from
      t.datetime :schedule_to
      t.references :availability_tutor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
