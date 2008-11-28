
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
  
  def find_all_rents_closed
    items = RentItem.find_all_by_movie_id(id, :conditions =>
      ['closed = 1']);
    rents = items.map {|i| i.rent}
  end
end

