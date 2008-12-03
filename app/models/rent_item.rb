class RentItem < ActiveRecord::Base
  belongs_to :movie
  belongs_to :member
  named_scope :open, :conditions => {:closed_at => nil} 
  named_scope :by_member, :order => 'member_id'
  named_scope :by_movie,  :order => 'movie_id'

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

  def close
    update_attribute(:closed, true);
  end
  
  def reopen
    update_attribute(:closed, false);
  end
end
