class AddUniversityToSubjects < ActiveRecord::Migration[7.2]
  def change
    add_reference :subjects, :university, null: false, foreign_key: true
  end
end
