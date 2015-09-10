class AddCountryToPeriods < ActiveRecord::Migration
  def change
    add_column :periods, :country, :string, null: false
    add_column :destinations, :zone, :string, null: false
    remove_column :destinations, :country
  end
end
