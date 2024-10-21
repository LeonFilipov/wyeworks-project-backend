class AddCountInterestedsToMeets < ActiveRecord::Migration[7.2]
  def change
    add_column :meets, :count_interesteds, :integer, default: 0
  end
end
