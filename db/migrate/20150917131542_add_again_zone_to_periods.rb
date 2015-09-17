class AddAgainZoneToPeriods < ActiveRecord::Migration
  def change
    add_column :periods, :zone, :string, null: false
    change_column :periods, :country, :string, null: true
  end
end
