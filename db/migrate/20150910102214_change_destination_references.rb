class ChangeDestinationReferences < ActiveRecord::Migration
  def change
    change_table :periods do |t|
      t.references :destination, index: true
      add_foreign_key :periods, :destinations
    end
    remove_column :periods, :user_id
  end
end
