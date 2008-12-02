class Rent < ActiveRecord::Base
  belongs_to :member
  has_many :items, :class_name => 'RentItem'

  def delay_in_days
    @delay_in_days ||= distancia(end_date, Time.now)
  end

  def distancia(from_time, to_time)
    from_time = normalize(from_time).to_time
    to_time = normalize(to_time).to_time
    ((((to_time - from_time))/(60 * 60 * 24))).to_i
  end

  def normalize(date)
    Time.utc(date.year, date.month, date.day)
  end

  def self.open
    items = RentItem.open
    rents = []
    items.each {|item| rents << item.rent unless rents.include? item.rent }
    rents
  end

  
  def self.find_all_begins_on(day)
    today, tomorrow = surround_days(day)
    rents = Rent.find(:all, :conditions =>
        ["closed = 0 AND begin_date > ? AND begin_date < ?",
        today, tomorrow], :order => 'begin_date DESC')
  end
  
  def self.find_all_ends_on(day)
    today, tomorrow = surround_days(day)
    rents = Rent.find(:all, :conditions =>
        ["closed = 0 AND end_date >= ? AND end_date < ?",
        today, tomorrow], :order => 'begin_date DESC')
  end
  
  def self.find_all_closed_on(day)
    today, tomorrow = surround_days(day)
    rents = Rent.find(:all, :conditions =>
        ["closed = ? AND close_date > ? AND close_date < ?",
        true, today, tomorrow],
      :order => 'begin_date DESC')
  end  
  
  def self.find_all_rented_on(day) 
    today, tomorrow = surround_days(day)
    rents = Rent.find(:all, :conditions => 
        ["begin_date > ? AND begin_date < ?",
        today, tomorrow])
  end
  
  def self.find_all_delayed_on(day)
    today, tomorrow = surround_days(day)
    rents = Rent.find(:all, :conditions =>
        ["closed = ? AND end_date < ?", false, today],
      :order => 'begin_date DESC')
  end  

  # TODO not DRY see member
  def self.surround_days(now)
    today = Time.utc(now.year, now.month, now.day)
    [today, today + 1.day]
  end 

  def self.find_current_of(member)
    today, tomorrow = surround_days(Time.now)
    Rent.find_by_member_id(member.id, :conditions =>
        ["closed = 0 AND begin_date > ? AND begin_date < ?", today, tomorrow])
  end

  def self.create_current_of(member)
    now = Time.now
    today, tomorrow = surround_days(now)
    Rent.new(:member_id => member.id, :closed => false,
      :begin_date => now, :end_date => tomorrow, 
      :prorrogue => 0)
  end    

  def ends_today?
    today, tomorrow = Rent.surround_days(Time.now)
    end_date >= today && end_date < tomorrow
  end
  
  def on_time?
    today, tomorrow = Rent.surround_days(Time.now)
    end_date < tomorrow
  end
  
  def close
    items.each {|i| i.update_attribute(:closed, true)}
    update_attributes(:closed => true, :close_date => Time.now)
  end
  
  def reopen
    items.each {|i| i.update_attribute(:closed, false)}
    update_attributes(:closed => false, :close_date => nil);
  end
  
  def state(time = Time.now)
    today, tomorrow = Rent.surround_days(time)
    logger.info "state for: #{time}"
    logger.info "begin_date: #{begin_date}"
    logger.info "end_date: #{end_date}"
    logger.info "close_date: #{close_date}"
    
    # #TODO chapuza!
    if closed?
      return 'closed' 
    elsif begin_date.strftime("%d/%m/%Y") == today.strftime("%d/%m/%Y")
      return 'opened' 
    elsif end_date.strftime("%d/%m/%Y") == today.strftime("%d/%m/%Y")
      return 'waiting' 
    else
      return 'delayed'
    end
  end
end
