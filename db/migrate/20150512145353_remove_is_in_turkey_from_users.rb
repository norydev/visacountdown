class RemoveIsInTurkeyFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :is_in_turkey, :boolean
  end
end
