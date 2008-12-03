class DateToFecha < ActiveRecord::Migration
  def self.up
    total = RentItem.count(:all)
    puts "total : " + total.to_s

    RentItem.find(:all).each do |item|
      item.begins_at = item.begin_date.to_db unless item.begin_date.nil?
      item.ends_at = item.end_date.to_db unless item.end_date.nil?
      item.closed_at = item.close_date.to_db unless item.close_date.nil?
      item.closed_at = Time.now.to_db if item.closed && item.close_date.nil?
      item.save(false)
      total = total - 1;
      puts("ahora: " + total.to_s) if total % 500 == 0
    end
  end

  def self.down
  end
end
