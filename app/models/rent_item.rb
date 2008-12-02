class RentItem < ActiveRecord::Base
  belongs_to :rent
  belongs_to :movie
  named_scope :open, :conditions => {:closed => false}, :order => 'id DESC'

  def close
    update_attribute(:closed, true);
  end
  
  def reopen
    update_attribute(:closed, false);
  end
end
