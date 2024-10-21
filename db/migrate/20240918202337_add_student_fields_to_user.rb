class AddStudentFieldsToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :attended_lessons, :integer, default: 0
    add_column :users, :attended_tutors, :integer, default: 0
    add_column :users, :attended_topics, :integer, default: 0
  end
end
