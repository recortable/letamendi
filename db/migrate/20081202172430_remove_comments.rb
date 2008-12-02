class RemoveComments < ActiveRecord::Migration
  def self.up
    drop_table :comments
  end

  def self.down
    create_table :comments do |t|
      t.column :text, :string
      t.column :type, :integer
      t.column :object, :integer
      t.column :created_at, :timestamp
    end
  end
end
