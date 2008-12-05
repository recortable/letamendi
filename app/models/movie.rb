
class Movie < ActiveRecord::Base
  has_many :closed_items, :class_name => 'RentItem', :foreign_key => 'movie_id',
    :conditions => ['closed_at IS NOT NULL'], :order => 'id DESC'
  has_one :open_item, :class_name => 'RentItem', :foreign_key => 'movie_id',
    :conditions => ['closed_at IS NULL'], :order => 'id DESC'
  belongs_to :tarifa

  def rented?
    !open_item.nil?
  end

end

