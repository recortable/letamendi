# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    def normalize(date)
        Time.utc(date.year, date.month, date.day)
    end
    
    def dias(days)
        if days > 0
            prefix = 'dentro de'
        else
            prefix = 'hace'
        end

        case days
            when 0  then 'hoy'
            when 1  then 'ma&ntilde;ana'
            when -1 then 'ayer'
            else "#{prefix} #{days.abs} d&iacute;as"
        end
    end

    def distancia(from_time, to_time)
        from_time = normalize(from_time).to_time
        to_time = normalize(to_time).to_time
        distance_in_days = ((((to_time - from_time))/(60 * 60 * 24))).to_i
    end

  def fecha(time)
    time.strftime("%d/%m/%Y")
  end
  
  def fecha_y_hora(time)
    time.strftime("%d/%m/%Y %H:%M")
  end
  
  def show_info(info)
    # TODO clear queue before
    page << "queue = Effect.Queues.get('info')"
    page << 'queue.each(function(e) { e.cancel () });'
    page.replace_html 'info', info
    page.visual_effect :appear, 'info', :duration => 0.5
    page.visual_effect :fade, 'info', :duration => 2.5, 
      :queue => {:position => 'end', :scope => 'info'}
  end
  
  def quick_info(info) 
    render :update do |page|
      page.show_info info
    end
  end

  def link_to_member(member)
    link_to member.name, :controller => 'socios', :action => 'ver', :id => member
  end
  
  def link_to_movie(movie) 
    link_to movie.title, :controller => 'pelis',
      :action => 'ver', :id => movie.number
  end
  
  def link_to_genre(genre_name)
    link_to genre_name, :controller => 'pelis',
      :action => 'genero', :id => genre_name
  end

  def link_to_director(director_name)
    link_to director_name, :controller => 'pelis',
      :action => 'director', :id => director_name
  end
end
