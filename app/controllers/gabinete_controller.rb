
class GabineteController < ApplicationController
    layout 'cinemascope'
    
    def index
      render :action => 'welcome'
    end
    
    def search 
      @term = params[:id]
      @members = Member.search(@term, :only => 'name')
      @movies = Movie.search(@term, :only => 'title')
    end
    
    
    
    def find_member
      num = params[:member]
      redirect_to :controller => 'socios', 
        :action => 'ver', :id => num
    end
    
    
    def find_movie
      num = params[:movie]
      redirect_to :controller => 'pelis', 
        :action => 'ver', :id => num
    end    
    
    
    
end
