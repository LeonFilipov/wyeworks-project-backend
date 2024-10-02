class RenameAssetToDescriptionInTopics < ActiveRecord::Migration[7.2]
  def change
    rename_column :topics, :asset, :description
  end
end