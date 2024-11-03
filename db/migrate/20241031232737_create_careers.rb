class CreateCareers < ActiveRecord::Migration[7.2]
  def change
    create_table :careers do |t|
      t.string :name
      t.references :university, null: false, foreign_key: true
      t.timestamps
    end
  end
end
