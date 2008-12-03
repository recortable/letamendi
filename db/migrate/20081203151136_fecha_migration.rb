class FechaMigration < ActiveRecord::Migration
  def self.up
    add_column 'rent_items', :begins_at, :string, :length => 8
    add_column 'rent_items', :ends_at, :string, :length => 8
    add_column 'rent_items', :closed_at, :string, :length => 8
  end

  def self.down
    remove_column 'rent_items', :begins_at
    remove_column 'rent_items', :ends_at
    remove_column 'rent_items', :closed_at
  end
end
