class MigrateDataToItems < ActiveRecord::Migration
  def self.up
    total = Rent.count(:all)
    puts "rents: " + total.to_s
    perform(total)
  end

  def self.perform(total)
    Rent.find(:all).each do |rent|
      rent.items.each do |item|
        if (item.begin_date.nil?)
          item.update_attribute(:begin_date, rent.begin_date)
          item.update_attribute(:end_date, rent.end_date)
          item.update_attribute(:close_date, rent.close_date)
          item.update_attribute(:member_id, rent.member_id)
        end
      end
      puts total.to_s if total % 100 == 0
      total = total - 1
    end

  end

  def self.down
  end
end