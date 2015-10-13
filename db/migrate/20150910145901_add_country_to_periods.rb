class AddCountryToPeriods < ActiveRecord::Migration
  def change
    add_column :periods, :country, :string, after: :last_day, null: false
    add_column :destinations, :zone, :string, after: :user_id, null: false
    remove_column :destinations, :country, :string
  end
end
