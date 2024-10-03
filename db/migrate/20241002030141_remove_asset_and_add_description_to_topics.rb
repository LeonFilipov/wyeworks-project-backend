class RemoveAssetAndAddDescriptionToTopics < ActiveRecord::Migration[7.2]
  def change
    remove_column :topics, :asset, :string
    add_column :topics, :description, :string
  end
end
