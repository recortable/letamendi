class RenameAutodateColumns < ActiveRecord::Migration
  def self.up
    rename_column :rents, :created_on, :begin_date
    rename_column :rents, :ends_on, :end_date
    rename_column :rents, :closed_on, :close_date
  end

  def self.down
    rename_column :rents, :begin_date, :created_on
    rename_column :rents, :end_date, :ends_on
    rename_column :rents, :close_date, :closed_on
  end
end
