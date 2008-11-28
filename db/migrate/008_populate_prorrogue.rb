class PopulateProrrogue < ActiveRecord::Migration
  def self.up
    Rent.update_all 'prorrogue = 0'
  end

  def self.down
  end
end
