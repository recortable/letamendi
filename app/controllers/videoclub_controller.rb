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
      flash[:error] = "La película con número #{params[:movie_number]} no existe."
    elsif movie.rented?
      flash[:error] = "La peli '#{movie.title}' está alquilada"
    else
      member.rent movie
      flash[:done] = "Peli '#{movie.title}' alquilada"
    end
    redirect_to :action => 'socio', :id => member.number
  end

  def alquiler_erroneo
    item = RentItem.find(params[:id])
    item.destroy
    flash[:notice] = "La peli '#{item.movie.title}' sigue alquilada."
    redirect_to :action => 'socio', :id => item.member.number
  end

  def devolver
    item = RentItem.find(params[:id])
    item.close
    flash[:done] = 'Peli devuelta'
    redirect_to :action => 'socio', :id => item.member.number
  end

  def nodevolver
    item = RentItem.find(params[:id])
    item.reopen
    flash[:notice] = "La peli '#{item.movie.title}' sigue devuelta"
    redirect_to :action => 'socio', :id => item.member.number
  end

end
