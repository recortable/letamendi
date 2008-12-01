class PelisController < ApplicationController
  layout 'cinemascope'
  
  def index
    lista
    render :action => 'lista'
  end
  
  def lista
    last = Movie.find(:first, :order => 'number DESC')
    number = last.number + 1
    @movie = Movie.new(:number => number) if !@movie
    @movies = Movie.paginate :page => params[:page], :order => 'number DESC'
  end
  
  def ver
    num = params[:id]
    @movie = Movie.find_by_number(num)
    if @movie.nil?
      @error = "no existe peli con n&uacute;mero #{num}"
      render :action => '/gabinete/error_page'
    else
      @closed_rents = @movie.find_all_rents_closed
      @rent = @movie.current_rent
    end
  end
  
  def director
    @director = params[:id]
    @movies = Movie.find_all_by_director(@director)
  end
  
  def genero
    @genre = params[:id]
    @movies = Movie.find_all_by_genre(@genre)
  end
  
  def rename_genre
    movies = Movie.find_all_by_genre(params[:id])
    name = params[:genre_renamed]
    movies.each do |movie|
      movie.update_attribute(:genre, name)
    end
    redirect_to :action => 'genero', :id => name
  end

  def rented_by
    movie = Movie.find_by_number(params[:id])
    @member = Member.find_by_number(params[:member_number])
    @rent = Rent.find_current_of @member
    @rent = Rent.create_current_of @member if @rent.nil? 
    @rent.save
    item = RentItem.new(:rent => @rent, :movie=> movie, 
      :closed => false, :price => 2.5);
    item.save
    redirect_to :controller => 'socios',
      :action => 'ver', :id => @member.number
  end
  
  
  def create
    @movie = Movie.new(params[:movie]);
    if @movie.save
      redirect_to :action => 'ver',
        :id => @movie.number
    else
      redirect_to :action => 'pelis'
    end
  end

  def delete
    m = Movie.find(params[:id])
    num = m.number - 1
    m.destroy
    redirect_to :action => 'ver', :id => m.number - 1 
  end
  
  def update
    @movie = Movie.find(params[:id])
    if @movie.update_attributes(params[:movie])
      @msg = 'los datos se han actualizado'
    else
      @msg = 'ERROR: los datos no se han podido guardar'
    end    
  end
  
end
