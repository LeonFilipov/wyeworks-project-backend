class RemoveFieldsFromAvailabilityTutors < ActiveRecord::Migration[7.2]
  def change
    remove_column :availability_tutors, :description, :string
    remove_column :availability_tutors, :link, :string
    remove_column :availability_tutors, :availability, :string
  end
end
