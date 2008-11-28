class MovieWithNumber < ActiveRecord::Migration
  def self.up
    add_column 'movies', 'number', :integer
  end

  def self.down
    remove_column 'movies', 'number'
  end
end
