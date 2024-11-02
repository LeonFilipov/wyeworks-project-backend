class AddLinkAndShowEmailToTopics < ActiveRecord::Migration[7.2]
  def change
    add_column :topics, :link, :string
    add_column :topics, :show_email, :boolean, default: false
  end
end
