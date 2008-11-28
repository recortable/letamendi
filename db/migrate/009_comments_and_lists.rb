class CommentsAndLists < ActiveRecord::Migration
  def self.up
     create_table :list_items do |t|
       t.column :name, :string
       t.column :parent, :integer
     end
     create_table :comments do |t|
       t.column :text, :string
       t.column :type, :integer
       t.column :object, :integer
       t.column :created_at, :timestamp
     end
      
      ListItem.create :id => 1, :name => 'listas', :parent => 0
  end

  def self.down
    drop_table :list_items
    drop_table :comments
  end
end
