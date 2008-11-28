class AlquileresController < ApplicationController
  layout 'cinemascope'

  def index
    params[:id] = Time.now
    lista
    render :action => 'lista'
  end

  def lista
    ms = params[:id].to_i
    now = Time.at(ms) if ms > 0
    now = Time.now if ms == 0
    @report = build_report(now)
  end

  def build_report(time) 
    @today = Time.utc(time.year, time.month, time.day)    
    report = Hash.new
    report[:day] = @today
    report[:next_day] = @today + 1.day
    report[:prev_day] = @today - 1.day
    report[:distance] = distance(Time.now, report[:day])
    report[:opened] = Rent.find_all_begins_on @today
    report[:closed] = Rent.find_all_closed_on @today
    report[:waiting] = Rent.find_all_ends_on @today
    report[:delayed] = Rent.find_all_delayed_on @today
    report[:rented] = Rent.find_all_rented_on @today
    report[:rents] = report[:rented].size
    today_items = report[:rented].map {|r| RentItem.count(
        :conditions => ['rent_id = ?', r.id])}
    total = 0;
    today_items.each {|n| total += n}
    report[:items] = total
    report
  end    
  
  def close_rent
    @rent = Rent.find(params[:id]);
    @rent.close
    @msg = "#{@rent.member.name} ha hecho los deberes..."
    render :action => 'update_rent'
  end
    
  def undo_close_rent
    @rent = Rent.find(params[:id]);
    @rent.reopen
    logger.info "state: #{@rent.state}"
    render :action => 'update_rent'
  end
    
  def close_item
    @item = RentItem.find(params[:id]);
    @rent = @item.rent
    @item.close
    items = RentItem.find_all_by_rent_id(@rent.id, 
      :conditions => ['closed = 0'])
    if items.size == 0
      @rent.update_attributes(:closed => true, 
        :close_date => Time.now)
      render :action => 'update_rent'
    else
      @msg = "#{@item.movie.title} marcada como devuelta"
      render :action => 'update_item'
    end
  end
    
  def undo_close_item
    @item = RentItem.find(params[:id])
    @rent = @item.rent
    @item.reopen
    if @rent.closed?
      @rent.update_attributes(:closed => false, 
        :close_date => nil);
      render :action => 'update_rent'  
    else
      @msg = "#{@item.movie.title} marcada como no devuelta"
      render :action => 'update_item'
    end
  end
  
  
  def prorrogue
    change_prorrogue 'le tendremos que dar un d&iacute;a m&aacute;s', 1
  end
  def undo_prorrogue
    change_prorrogue 'un d&iacute;a menos... a ver si espabila', -1
  end
  
  def change_prorrogue(msg, num)
    @msg = msg
    @rent = Rent.find(params[:id])
    @rent.update_attribute(:prorrogue, 
      @rent.prorrogue + num)
    render :action => 'update_item'
  end
end
