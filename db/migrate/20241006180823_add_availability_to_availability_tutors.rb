class AddAvailabilityToAvailabilityTutors < ActiveRecord::Migration[7.2]
  def change
    add_column :availability_tutors, :availability, :string
  end
end
