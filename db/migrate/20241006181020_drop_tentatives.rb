class DropTentatives < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :tentatives, :availability_tutors
    drop_table :tentatives
  end
end
