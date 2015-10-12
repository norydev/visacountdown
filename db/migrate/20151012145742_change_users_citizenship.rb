class ChangeUsersCitizenship < ActiveRecord::Migration
  def change
    change_column :users, :citizenship, :string, null: false, default: "None"
  end
end
