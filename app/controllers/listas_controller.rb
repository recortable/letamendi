class ListasController < ApplicationController
  layout 'cinemascope'
  
  def index
    redirect_to :action => 'listas', :id => 1
  end
  
  def listas
    @item = ListItem.find(params[:id])
  end
  
  def add
    @parent = ListItem.find(params[:id])
    @child = ListItem.new(:parent => @parent.id,
      :name => params[:text])
    @child.save
  end
end
