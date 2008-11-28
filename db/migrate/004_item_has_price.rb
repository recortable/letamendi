class ItemHasPrice < ActiveRecord::Migration
  def self.up
    add_column 'rent_items', 'price', :float
  end

  def self.down
    remove_column 'rent_items', 'price'
  end
end
