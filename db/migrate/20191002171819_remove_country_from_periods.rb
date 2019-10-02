class RemoveCountryFromPeriods < ActiveRecord::Migration[6.0]
  def change
    remove_column :periods, :country, :string
  end
end
