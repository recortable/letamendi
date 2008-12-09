class RentItem < ActiveRecord::Base
  belongs_to :movie
  belongs_to :member
  named_scope :open, :conditions => {:closed_at => nil}
  named_scope :open_today, :conditions => {:begins_at =>   Time.now.to_db}
  named_scope :delayed, :conditions => ['ends_at < ? AND closed_at IS NULL', Time.now.to_db]
  named_scope :waiting, :conditions => {:ends_at => Time.now.to_db, :closed_at => nil}
  named_scope :by_member, :order => 'member_id'
  named_scope :by_movie,  :order => 'movie_id'
  named_scope :by_end_date, :order => 'ends_at'
  has_one :pasta, :dependent => :destroy, :foreign_key => 'item_id'

  def open?
    closed_at == nil
  end

  def closed?
    !open?
  end

  def open_today?
    open? && begins_at == Time.now.to_db
  end

  def closed_today?
    closed? && closed_at == Time.now.to_db
  end

  def delayed?
    open? && ends_at < Time.now.to_db
  end

  def waiting?
    ends_at == Time.now.to_db
  end

  def delay_in_days
    @delay_in_days ||= distancia(Time.from_db(ends_at), Time.now)
  end

  def distancia(from_time, to_time)
    from_time = normalize(from_time).to_time
    to_time = normalize(to_time).to_time
    ((((to_time - from_time))/(60 * 60 * 24))).to_i
  end

  def normalize(date)
    Time.utc(date.year, date.month, date.day)
  end

end
