class AddCitizenshipToUsers < ActiveRecord::Migration
  def change
    add_column :users, :citizenship, :string
  end
end
