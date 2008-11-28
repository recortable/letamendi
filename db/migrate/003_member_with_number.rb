class MemberWithNumber < ActiveRecord::Migration
  def self.up
    add_column 'members', 'number', :integer
  end

  def self.down
    remove_column 'members', 'number'
  end
end
