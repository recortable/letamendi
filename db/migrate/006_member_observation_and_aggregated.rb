class MemberObservationAndAggregated < ActiveRecord::Migration
  def self.up
      add_column :members, :comments, :string
      add_column :members, :friends, :string
  end

  def self.down
      remove_column :members, :comments
      remove_column :members, :friends
  end
end
