class RemoveDescriptionAndModeFromMeets < ActiveRecord::Migration[7.2]
  def change
    remove_column :meets, :description, :string
    remove_column :meets, :mode, :string
  end
end
