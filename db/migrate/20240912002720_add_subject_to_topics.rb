class AddSubjectToTopics < ActiveRecord::Migration[7.2]
  def change
    add_reference :topics, :subject, null: false, foreign_key: true
  end
end
