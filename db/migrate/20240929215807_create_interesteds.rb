class CreateInteresteds < ActiveRecord::Migration[7.2]
  def change
    create_table :interesteds do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :availability_tutor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
