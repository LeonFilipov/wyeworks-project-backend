class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :email
      t.string :uid
      t.string :description
      t.string :image_url
      t.timestamps
    end
  end
end
