class ChangePeriodsDatesToNonNull < ActiveRecord::Migration
  def change
    change_column :periods, :first_day, :date, null: false
    change_column :periods, :last_day, :date, null: false
  end
end
