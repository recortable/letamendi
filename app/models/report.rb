
class Report 
  attr_accessor :day

  def initialize(time)
    @day = Time.utc(time.year, time.month, time.day)
  end

  def distance
    @distance ||= distance_in_days Time.now, @day
  end

  def prev_day
    (@day - 1.day).to_i
  end

  def next_day
    (@day + 1.day).to_i
  end

  def rented
    @rented ||= Rent.find_all_rented_on @day
  end

  def opened
    @opened ||= Rent.find_all_begins_on @day
  end

  def closed
    @closed ||= Rent.find_all_closed_on @day
  end

  def waiting
    @waiting ||= Rent.find_all_ends_on @day
  end

  def delayed
    @delayed ||= Rent.find_all_delayed_on @day
  end

  def items
    today_items = rented.map do |r|
      RentItem.count(:conditions => ['rent_id = ?', r.id])
    end
    total = 0;
    today_items.each {|n| total += n}
    total
  end

  def rents
    rented.size
  end



  private
  def normalize(date)
    Time.utc(date.year, date.month, date.day)
  end

  def distance_in_days(from_time, to_time)
    from_time = normalize(from_time).to_time
    to_time = normalize(to_time).to_time
    ((to_time - from_time)/(60 * 60 * 24)).to_i
  end

end