module VideoclubHelper

  def title(page_title)
    content_for(:title) { page_title }
  end

  def fecha(encoded)
    encoded[6..7] + '/' + encoded[4..5] + '/' + encoded[0..3] unless encoded.nil?
  end

  def precio(price)
    price.nil? ? '0.00' : (price.to_f / 100).to_s
  end

  def retraso(item)
    days = item.delay_in_days
    return content_tag :div, "#{days} #{say_dia days} de retraso", :class => 'delayed' if days > 0
    return content_tag :div, "falta #{-1 * days} #{say_dia days}", :class => 'open' if days < 0
    return content_tag :div, "hoy", :class => 'waiting' if days == 0
  end

  def say_dia(days)
    days == -1 || days == 1 ? 'dia' : 'dias'
  end

  def class_of_pasta(pasta)
    return 'error' if pasta.nil? || pasta.price.nil?
    return 'closed' if pasta.closed?
    return 'deuda' if pasta.price > 0
    return 'pago' if pasta.price < 0
  end

  def class_of_item(item)
    return 'today' if item.closed_today?
    return 'closed' if item.closed?
    return 'delayed' if item.delayed?
    return 'waiting' if item.waiting?
    return 'open' if item.open?
  end

  def link_to_movie(movie)
    link_to(movie.title, {:controller => 'videoclub', :action => 'peli', :id => movie.number}) unless movie.nil?
  end
  
  def link_to_member(member)
    link_to(member.name, {:controller => 'videoclub', :action => 'socio', :id => member.number}) unless member.nil?
  end

  def empty_link(label, id, html_class = '')
    '<a href="" onclick="javascript:void(0);" id="' + id.to_s + '" class="' + html_class + '" />' + label + '</a>'
  end

  MESES = %w(enero febrero marzo abril mayo junio julio agosto septiembre octubre noviembre diciembre) 

  def select_day
    select_date Time.new,  :order => [:day, :month, :year],
    :date_separator => 'de ', :start_year => 2007, :use_month_names => MESES
  end

  def select_month
    select_date Time.new,  :order => [:day, :month, :year],
     :start_year => 2007, :discard_day => true,  :use_month_names => MESES
  end

end
