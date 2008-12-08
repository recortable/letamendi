
class Movie < ActiveRecord::Base
  has_many :closed_items, :class_name => 'RentItem', :foreign_key => 'movie_id',
    :conditions => ['closed_at IS NOT NULL'], :order => 'id DESC'
  has_one :open_item, :class_name => 'RentItem', :foreign_key => 'movie_id',
    :conditions => ['closed_at IS NULL'], :order => 'id DESC'
  belongs_to :tarifa
  has_many :pastas

  def self.new_with_number
    last = Movie.find(:first, :order => 'number DESC')
    Movie.new(:number => last.number + 1)
  end

  def rented?
    !open_item.nil?
  end

end

