
class Member < ActiveRecord::Base
  has_many :rents
  
  def find_all_rents_ends_on(day)
    today, tomorrow = surround_days(day)
    Rent.find_all_by_member_id(id, :conditions =>
      ['closed = 0 AND end_date >= ? AND end_date < ?', 
      today, tomorrow])
  end
  
  def find_all_rents_delayed_on(day)
    today, tomorrow = surround_days(day)
    Rent.find_all_by_member_id(id, :conditions =>
      ['closed = 0 AND end_date < ?', today])
  end
  
  def find_all_rents_closed
    Rent.find_all_by_member_id(id, :conditions =>
      ['closed = 1'])
  end

  # TODO not DRY see rent
  def surround_days(now)
    today = Time.utc(now.year, now.month, now.day)
    tomorrow = today + 1.day
    [today, tomorrow]
  end 

end
