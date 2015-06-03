class AddZoneToPeriods < ActiveRecord::Migration
  def change
    add_column :periods, :zone, :string, default: "Turkey", null: false
  end
end
