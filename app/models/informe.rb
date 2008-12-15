
class Informe
  def initialize(dbtime)
    @dbtime = dbtime
  end

  def fecha
    @dbtime
  end

  def item_count
    @item_count ||= RentItem.count(:all, :conditions => ['begins_at = ?', @dbtime])
  end

  def pasta
    @pasta ||= Pasta.find_all_by_closed_at(@dbtime)
  end

  def total_pasta
    @pasta_total ||= pasta.inject(0) {|sum, p| sum + p.price}
  end

end