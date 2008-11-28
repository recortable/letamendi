class RepairClosedRents < ActiveRecord::Migration
  def self.up
    closed = Rent.find(:all, :conditions => 'closed = 1')
    closed.each do |r|
      end_date = r.end_date
      end_day = Time.utc(end_date.year, end_date.month, end_date.day)
      r.update_attribute(:close_date, end_day)
    end
  end

  def self.down
  end
end
