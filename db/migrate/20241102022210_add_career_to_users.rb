class AddCareerToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :career, null: true, foreign_key: true
  end
end
