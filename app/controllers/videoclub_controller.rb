class VideoclubController < ApplicationController

  def index
  end

  def ver
    redirect_to :action => 'socio', :id => params[:member_id] if params[:member_id]
    redirect_to :action => 'peli', :id => params[:movie_id] if params[:movie_id]
  end

  def socio
    @member = Member.find_by_number(params[:id])
  end

  def peli
    @movie = Movie.find_by_number(params[:id])
  end

  def alquilar
    member = Member.find(params[:id])
    movie = Movie.find_by_number(params[:movie_number])
    if movie.nil?
      flash[:notice] = "La película con número #{params[:movie_number]} no existe."
    else
      member.rent movie
      flash[:notice] = "Peli '#{movie.title}' alquilada"
    end
    redirect_to :action => 'socio', :id => member.number
  end

  def devolver
    item = RentItem.find(params[:id])
    item.close
    flash[:notice] = 'Peli devuelta'
    redirect_to :action => 'socio', :id => item.member.number
  end

  def nodevolver
    item = RentItem.find(params[:id])
    item.reopen
    flash[:notice] = "La peli '#{item.movie.title}' sigue devuelta"
    redirect_to :action => 'socio', :id => item.member.number
  end

end
