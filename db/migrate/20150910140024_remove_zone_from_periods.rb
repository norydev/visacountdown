class RemoveZoneFromPeriods < ActiveRecord::Migration
  def change
    remove_column :periods, :zone
  end
end
