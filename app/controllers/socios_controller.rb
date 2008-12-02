class SociosController < ApplicationController
  layout 'cinemascope'

  def index
    lista
    render :action => 'lista'
  end

  def lista
    last = Member.find(:first, :order => 'number DESC')
    @number = last.number + 1
    @member = Member.new(:number => @number) if !@member
    @members = Member.paginate :page => params[:page], :order => 'number DESC'
  end


  def ver
    num = params[:id]
    @member = Member.find_by_number(num)
    if @member.nil?
      render :text => "Error: no existe socio con n&uacute;mero #{num}"
    else
      @rent = Rent.find_current_of @member
      @waiting_rents = @member.find_all_rents_ends_on Time.now
    end
  end

  def create 
    @member = Member.new(params[:member]);
    if @member.save
      redirect_to :action => 'ver', 
        :id => @member.number 
    else
      redirect_to :action => 'lista' 
    end
  end  

  def delete
    m = Member.find(params[:id])
    num = m.number - 1
    m.destroy
    redirect_to :action => 'ver', :id => m.number - 1 
  end
  
  def update
    @member = Member.find(params[:id])
    if @member.update_attributes(params[:member])
      @msg = 'los datos se han actualizado'
    else
      @msg = 'ERROR: los datos no se han podido guardar'
    end    
  end
  
  def rent
    @member = Member.find_by_number(params[:id]);
    @movie = Movie.find_by_number(params[:movie_number])
    @rent = Rent.find_current_of @member
    @rent = Rent.create_current_of(@member) if @rent.nil? 

    if @movie.nil?
      show_info "la peli #{params[:movie_number]} no existe"
    elsif @movie.rented?
      show_info "la peli #{params[:movie_number]} est&aacute; alquilada"
    else      
      childs = 0
      childs = RentItem.count(:conditions => 
          ['rent_id = ?', @rent.id]) if !@rent.new_record?
      if childs == 1
        @rent.update_attribute(:end_date, @rent.end_date + 1.day)
        @date_changed = true
      end
      @item = RentItem.new(:rent => @rent, :movie=> @movie, 
        :closed => false, :price => 2.5);
      @item.save
      render :action => 'rent'
    end
  end
  
  def undo_rent
    @id = params[:id]
    item = RentItem.find(@id)
    childs = RentItem.count(:conditions => 
        ['rent_id = ?', item.rent.id])
    if childs == 2
      @rent = item.rent
      @rent.update_attribute(:end_date, item.rent.end_date - 1.day)
      @date_changed = true
    end
    RentItem.delete(@id);
  end
  
  def day_more
    change_end_date 'un d&iacute;a m&aacute;s', 1
  end
        
  def day_less
    change_end_date 'un d&iacute;a menos', -1
  end

  def change_end_date(msg, number)
    @msg = msg
    @rent = Rent.find(params[:id])
    @rent.update_attribute(:end_date,
      @rent.end_date + number.day)
    render :action => 'update_dates'
  end
  
  def prorrogue
    prorrogue_rent 'un d&iacute;a m&aacute;s', 1
  end
  def undo_prorrogue
    prorrogue_rent 'a darse prisa!', -1
  end
    
  def prorrogue_rent(msg, num)
    @msg = msg
    @rent = Rent.find(params[:id])
    @rent.update_attribute(:prorrogue,
      @rent.prorrogue + num)
    render :action => 'update_dates'
  end
end
