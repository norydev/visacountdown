class AddLatestEntryToDestination < ActiveRecord::Migration
  def change
    add_column :destinations, :latest_entry, :date
  end
end
