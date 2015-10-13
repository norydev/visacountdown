class RemoveDestinationFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :destination
  end
end
