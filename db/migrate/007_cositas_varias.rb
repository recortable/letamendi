class CositasVarias < ActiveRecord::Migration
  def self.up
     add_column :movies, :section, :string
     add_column :movies, :rent_count, :integer
     add_column :members, :rent_count, :integer     
     add_column :rents, :prorrogue, :integer
     add_index :rents, :closed
     add_index :rents, :begin_date
     add_index :rents, :end_date
  end

  def self.down
    remove_column :movies, :section
    remove_column :movies, :rent_count
    remove_column :members, :rent_count
    remove_column :rents, :prorrogue
    remove_index :rents, :closed
     remove_index :rents, :begin_date
     remove_index :rents, :end_date
  end
end
