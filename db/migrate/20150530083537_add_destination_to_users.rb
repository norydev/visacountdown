class AddDestinationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :destination, :string
  end
end
