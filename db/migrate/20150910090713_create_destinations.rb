class CreateDestinations < ActiveRecord::Migration
  def change
    create_table :destinations do |t|
      t.references :user, index: true
      t.string :country, null: false

      t.timestamps null: false
    end
    add_foreign_key :destinations, :users
  end
end
