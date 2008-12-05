class CreateTarifas < ActiveRecord::Migration
  def self.up
    create_table :tarifas do |t|
      t.string :name
      t.integer :price
      t.integer :delay_price
      t.integer :extend_price
      t.integer :days_to_rent
      t.timestamps
    end

    t = Tarifa.new(:id => 1, :name => 'normal')
    t.save

    add_column :movies, :tarifa_id, :integer, :default => 1
  end

  def self.down
    drop_table :tarifas
    remove_column :movies, :tarifa_id
  end
end
