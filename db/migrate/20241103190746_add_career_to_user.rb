class AddCareerToUser < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :career, foreign_key: true
  end
end
