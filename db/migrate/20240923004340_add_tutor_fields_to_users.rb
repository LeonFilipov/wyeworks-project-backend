class AddTutorFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :ranking, :integer
    add_column :users, :amount_given_lessons, :integer
    add_column :users, :amount_given_topics, :integer
    add_column :users, :amount_attended_students, :integer
  end
end
