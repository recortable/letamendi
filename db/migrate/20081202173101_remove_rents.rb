class RemoveRents < ActiveRecord::Migration
  def self.up
    add_column 'rent_items', :member_id, :integer
    add_column 'rent_items', :begin_date, :timestamp
    add_column 'rent_items', :end_date, :timestamp
    add_column 'rent_items', :close_date, :timestamp
  end

  def self.down
    remove_column 'rent_items', :member_id
    remove_column 'rent_items', :begin_date
    remove_column 'rent_items', :end_date
    remove_column 'rent_items', :close_date
  end
end
