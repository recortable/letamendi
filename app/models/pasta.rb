class Pasta < ActiveRecord::Base
  belongs_to :movie
  belongs_to :member
  belongs_to :item, :class_name => 'RentItem', :foreign_key => 'item_id'
  named_scope :opened, :conditions => {:closed_at => nil}
  named_scope :closed_today, :conditions => {:closed_at => Time.now.to_db}

  def closed?
    !open?
  end

  def open?
    closed_at.nil?
  end

  def close
    update_attribute(:closed_at, Time.now.to_db)
  end

  def reopen
    update_attribute(:closed_at, nil)
  end

  def euros
    price.nil? ? '0.00' : (price.to_f / 100).to_s
  end
end
