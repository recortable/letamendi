class CreatePastas < ActiveRecord::Migration
  def self.up
    create_table :pastas do |t|
        t.string :description
        t.integer :member_id
        t.integer :movie_id
        t.integer :item_id
        t.string :open_at, :length => 8
        t.string :closed_at, :lenth => 8
        t.integer :price
    end
  end

  def self.down
    drop_table :pastas
  end
end
