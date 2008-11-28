class RentsController < ApplicationController
  layout 'cinemascope'
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @rent_pages, @rents = paginate :rents, :per_page => 100, 
      :order => 'begin_date DESC'
  end

  def show
    @rent = Rent.find(params[:id])
  end

  def new
    @rent = Rent.new
  end

  def create
    @rent = Rent.new(params[:rent])
    if @rent.save
      flash[:notice] = 'Rent was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @rent = Rent.find(params[:id])
  end

  def update
    @rent = Rent.find(params[:id])
    if @rent.update_attributes(params[:rent])
      flash[:notice] = 'Rent was successfully updated.'
      redirect_to :action => 'show', :id => @rent
    else
      render :action => 'edit'
    end
  end

  def destroy
    Rent.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
