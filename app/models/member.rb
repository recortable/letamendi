
class Member < ActiveRecord::Base
  has_many :rent_items, :order => 'id DESC'
  has_many :closed_items, :class_name => 'RentItem', :foreign_key => 'member_id',
    :conditions => ['closed_at IS NOT NULL'], :order => 'id DESC'
  has_many :open_items, :class_name => 'RentItem', :foreign_key => 'member_id',
    :conditions => ['closed_at IS NULL'], :order => 'id DESC'
  has_many :closed_today_items, :class_name => 'RentItem', :foreign_key => 'member_id',
    :conditions => ['closed_at IS NOT NULL AND closed_at = ?', Time.now.to_db], :order => 'id DESC'
  has_many :closed_not_today_items, :class_name => 'RentItem', :foreign_key => 'member_id',
    :conditions => ['closed_at IS NOT NULL AND closed_at <> ?', Time.now.to_db], :order => 'id DESC'

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

  def rent_back(item)
    Member.transaction do
      delay = item.delay_in_days
      if delay > 0
        pasta = Pasta.new(:member_id => self.id, :movie_id => item.movie.id, :item_id => item.id)
        pasta.open_at = Time.now.to_db
        pasta.price = item.movie.tarifa.delay_price.to_i * delay
        pasta.description = "Retraso de #{delay} dias al devolver '#{item.movie.title}'"
        pasta.save!
      end
      item.update_attribute(:closed_at, Time.now.to_db)
    end
  end

  def undo_rent_back(item)
    Member.transaction do
      pasta = Pasta.find_by_item_id(item.id)
      pasta.destroy unless pasta.nil?
      item.update_attribute(:closed_at, nil)
    end
  end

  def pending_pasta?
    pending_pasta.size > 0
  end

  def pending_total
    pending_pasta.inject(0) {|sum, pasta| sum + pasta.price}
  end

  def buy(description, price)
    Member.transaction do
      pasta = Pasta.new(:member_id => self.id)
      pasta.description = description
      pasta.price = price
      pasta.open_at = Time.now.to_db
      pasta.save!
    end
  end

end
