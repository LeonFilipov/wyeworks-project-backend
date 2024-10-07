class RemoveDateToAndDateFromFromAvailabilityTutors < ActiveRecord::Migration[7.2]
  def change
    remove_column :availability_tutors, :date_to, :datetime
    remove_column :availability_tutors, :date_from, :datetime
  end
end
