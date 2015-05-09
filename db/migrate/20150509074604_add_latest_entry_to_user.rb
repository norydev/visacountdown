class AddLatestEntryToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_in_turkey, :boolean, default: false
    add_column :users, :latest_entry, :date
  end
end
