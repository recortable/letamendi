
class Movie < ActiveRecord::Base
  def rented?
    !current_item.nil?
  end

  def current_item
    RentItem.find_by_movie_id(id, :conditions =>
      ["closed = ?", false]);
  end  
  
  def current_rent
    item = current_item
    item.rent if !item.nil?
  end

  def closed_items
    RentItem.find(:all, :conditions => ['movie_id = ? AND closed = 1', self.id])
  end
end

