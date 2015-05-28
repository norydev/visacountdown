class AddOmniauthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :picture, :string
    add_column :users, :cover_picture, :string
    add_column :users, :name, :string
    add_column :users, :nickname, :string
    add_column :users, :location, :string
    add_column :users, :time_zone, :string
    add_column :users, :description, :string
    add_column :users, :website, :string
    add_column :users, :twitter, :string
    add_column :users, :token, :string
    add_column :users, :token_expiry, :datetime
  end
end
