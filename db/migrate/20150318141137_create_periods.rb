class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.references :user, index: true
      t.date :first_day
      t.date :last_day

      t.timestamps null: false
    end
    add_foreign_key :periods, :users
  end
end
