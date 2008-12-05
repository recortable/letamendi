class MovieComments < ActiveRecord::Migration
  def self.up
    add_column :movies, :comments, :string
    remove_column :movies, :rent_count
  end

  def self.down
    add_column :movies, :rent_count, :integer
    remove_column :movies, :comments
  end
end
