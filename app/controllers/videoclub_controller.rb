class VideoclubController < ApplicationController

  def index
    @info = Informe.new(Time.now.to_db)
  end

  def ver
    redirect_to :action => 'socio', :id => params[:member_id] if params[:member_id]
    redirect_to :action => 'peli', :id => params[:movie_id] if params[:movie_id]
  end

  def socio
    @member = Member.find_by_number(params[:id])
  end

  def editar_socio
    @member = params[:id] ? Member.find(params[:id]) : Member.new_with_number
  end

  def guardar_socio
    member = params[:id] ? Member.find(params[:id]) : Member.new
    if member.update_attributes params[:member]
      flash[:done] = "Datos de '#{member.name}' guardados."
    else
      false[:error] = "Error guardando los datos de socia. Inténtalo de nuevo"
    end
    redirect_to_member(member);
  end

  def peli
    @movie = Movie.find_by_number(params[:id])
  end

  def editar_peli
    @movie = params[:id] ? Movie.find(params[:id]) : Movie.new_with_number
  end

  def guardar_peli
    movie = params[:id] ? Movie.find(params[:id]) : Movie.new
    if movie.update_attributes params[:movie]
      flash[:done] = "Datos de '#{movie.title}' guardados."
    else
      false[:error] = "Error guardando los datos de la peli. Inténtalo de nuevo"
    end
    redirect_to_movie movie
  end

  def alquilar
    member = Member.find(params[:id])
    movie = Movie.find_by_number(params[:movie_number])
    if movie.nil?
      flash[:error] = "La película con número #{params[:movie_number]} no existe."
    elsif movie.rented?
      flash[:error] = "La peli (#{movie.number}) '#{movie.title}' ya estaba alquilada"
    else
      member.rent movie
      flash[:done] = "Peli (#{movie.number}) '#{movie.title}' alquilada"
    end
    redirect_to_member member
  end

  def alquiler_erroneo
    item = RentItem.find(params[:id])
    item.member.undo_rent item
    flash[:done] = "La peli (#{item.movie.number}) '#{item.movie.title}' ya NO está alquilada"
    redirect_to_member item.member
  end

  def devolver
    item = RentItem.find(params[:id])
    item.member.rent_back item
    flash[:done] = 'Peli devuelta'
    redirect_to_member item.member
  end

  def nodevolver
    item = RentItem.find(params[:id])
    item.member.undo_rent_back item
    flash[:notice] = "La peli (#{item.movie.number}) '#{item.movie.title}' sigue devuelta"
    redirect_to_member item.member
  end

  def editar_tarifa
    @tarifa = params[:id] ? Tarifa.find(params[:id]) : Tarifa.new
  end

  def guardar_tarifa
    tarifa = params[:id] ? Tarifa.find(params[:id]) : Tarifa.new
    if tarifa.update_attributes params[:tarifa]
      flash[:done] = "Tarifa #{tarifa.name} actualizada."
    else
      false[:error] = "Error guardando la tarifa. Inténtalo de nuevo"
    end
    redirect_to :action => 'index'
  end

  def comprar
    member = Member.find params[:id]
    member.buy(params[:description], params[:price])
    redirect_to_member member
  end

  def des_comprar
    pasta = Pasta.find params[:id]
    pasta.destroy if pasta.item.nil?
    redirect_to_member pasta.member
  end

  def cobrar
    pasta = Pasta.find params[:id]
    pasta.close
    flash[:done] = "Se han cobrado #{pasta.euros}€ del #{pasta.description}"
    redirect_to_member pasta.member
  end

  def des_cobrar
    pasta = Pasta.find params[:id]
    pasta.reopen
    flash[:done] = "Se han devuelto #{pasta.euros}€ del #{pasta.description}"
    redirect_to_member pasta.member
  end

  def cobrar_todo
    member = Member.find(params[:id])
    member.pending_pasta.each {|pasta| pasta.close}
    flash[:done] = "Se cobraron todas las deudas de #{member.name}"
    redirect_to_member member
  end

  def search
    @term = params[:term]
    @members = Member.search(@term)
    @movies = Movie.search(@term)
    render :action => 'search', :layout => false
  end

  def informe_diario
    date = params[:date]
    fecha = Time.utc(date[:year], date[:month], date[:day])
    @info = Informe.new(fecha.to_db)
  end

  def informe_mensual
    @info = InformeMensual.new(params[:date][:month], params[:date][:year])
  end


  private
  def redirect_to_member(member)
    redirect_to :action => 'socio', :id => member.number
  end

  def redirect_to_movie(movie)
    redirect_to :action => 'peli', :id => movie.number
  end


end
