class AddCareerIdToSubjectsAndRemoveUniversityId < ActiveRecord::Migration[7.2]
  def change
    add_reference :subjects, :career, foreign_key: true
    remove_reference :subjects, :university, foreign_key: true
  end
end
