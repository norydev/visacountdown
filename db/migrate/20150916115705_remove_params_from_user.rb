class RemoveParamsFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :latest_entry, :date
    remove_column :users, :picture, :string
    remove_column :users, :cover_picture, :string
    remove_column :users, :name, :string
    remove_column :users, :nickname, :string
    remove_column :users, :location, :string
    remove_column :users, :time_zone, :string
    remove_column :users, :description, :string
    remove_column :users, :website, :string
    remove_column :users, :twitter, :string
    remove_column :users, :facebook, :string
  end
end