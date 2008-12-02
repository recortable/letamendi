class RemoveRents < ActiveRecord::Migration
  def self.up
    add_column :rent_items, :begin_date, :time_stamp
    add_column :rent_items, :end_date, :time_stamp
    add_column :rent_items, :close_date, :time_stamp
    add_column :rent_items, :member_id, :reference
    add_column :rent_items, :movie_id, :reference

    Rent.find(:all).each do |rent|
      rent.items.each do |item|
        item.update_column(:begin_date, rent.begin_date)
        item.update_column(:end_date, rent.end_date)
        item.update_column(:close_date, rent.close_date)
        item.update_column(:member_id, rent.member_id)
        item.update_column(:movie_id, rent.movie_id)
      end
    end
  end

  def self.down
  end
end
