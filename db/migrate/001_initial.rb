class Initial < ActiveRecord::Migration
  def self.up
     create_table :members do |t|
       t.column :name, :string
       t.column :address, :string
       t.column :email, :string
       t.column :telephone, :string
     end
     
     create_table :movies do |t|
       t.column :title, :string
       t.column :director, :string
       t.column :genre, :string
       t.column :crew, :string
       t.column :year, :integer
     end
     
     create_table :rents do |t|
       t.column :member_id, :integer
       t.column :closed, :boolean
       t.column :created_on, :timestamp
       t.column :ends_on, :timestamp
       t.column :closed_on, :timestamp
       t.column :price, :float
       t.column :extra, :float
     end
     
     create_table :rent_items do |t|
       t.column :rent_id, :integer
       t.column :movie_id, :integer
       t.column :closed, :boolean
     end  
  end

  def self.down
    drop_table :members
    drop_table :movies
    drop_table :rents
    drop_table :rent_items
  end
end
