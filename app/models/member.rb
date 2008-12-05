
class Member < ActiveRecord::Base
  has_many :rent_items, :order => 'id DESC'
  has_many :closed_items, :class_name => 'RentItem', :foreign_key => 'member_id',
    :conditions => ['closed_at IS NOT NULL'], :order => 'id DESC'
  has_many :open_items, :class_name => 'RentItem', :foreign_key => 'member_id',
    :conditions => ['closed_at IS NULL'], :order => 'id DESC'

  has_many :pastas
  has_many :pending_pasta, :class_name => 'Pasta', :foreign_key => 'member_id',
    :conditions => ['closed_at IS NULL'], :order => 'id DESC'
  has_many :closed_pasta, :class_name => 'Pasta', :foreign_key => 'member_id',
    :conditions => ['closed_at IS NOT NULL'], :order => 'id DESC'
  has_many :closed_pasta_today, :class_name => 'Pasta', :foreign_key => 'member_id',
    :conditions => ['closed_at IS NOT NULL AND closed_at = ?', Time.now.to_db], :order => 'id DESC'

  
  def items
    RentItem.find(:all, :include => [:movie, :member], :conditions => ['rent_items.member_id = ?', self.id] )
  end

  def rent(movie)
    if !movie.rented?
      Member.transaction do
        item = RentItem.new(:member_id => self.id, :movie_id => movie.id)
        item.begins_at = Time.now.to_db
        item.ends_at = (Time.now + 1.day).to_db
        item.save!
        pasta = Pasta.new(:member_id => self.id, :movie_id => movie.id, :item_id => item.id)
        pasta.open_at = item.begins_at
        pasta.price = movie.tarifa.price
        pasta.description = "Alquiler de '#{movie.title}' realizado por '#{self.name}"
        pasta.save!
      end
    end
  end

  def pending_pasta?
    pending_pasta.size > 0
  end

  def pending_total
    pending_pasta.inject(0) {|sum, pasta| sum + pasta.price}
  end

  # DEPRECATED
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
  
  def closed_rents
    Rent.find(:all, :conditions => ['member_id = ? AND closed = 1', self.id], :order => 'begin_date DESC')
  end

  # TODO not DRY see rent
  def surround_days(now)
    today = Time.utc(now.year, now.month, now.day)
    tomorrow = today + 1.day
    [today, tomorrow]
  end 

end
