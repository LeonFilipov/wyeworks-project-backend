class ChangeDescriptionTypeInTopics < ActiveRecord::Migration[7.2]
  def change
    change_column :topics, :description, :string
  end
end
