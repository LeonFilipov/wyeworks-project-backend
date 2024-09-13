class AddTopicToTags < ActiveRecord::Migration[7.2]
  def change
    add_reference :tags, :topic, null: false, foreign_key: true
  end
end
