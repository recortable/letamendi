module VideoclubHelper

  def fecha(encoded)
    encoded[6..7] + '/' + encoded[4..5] + '/' + encoded[0..3] unless encoded.nil?
  end

  def precio(price)
    price.nil? ? '0.00' : (price.to_f / 100).to_s
  end

  def retraso(item)
    days = item.delay_in_days
    return content_tag :div, "#{days} dias de retraso", :class => 'delayed' if days > 0
#    return content_tag :div, "faltan #{-1 * days} dias", :class => 'open' if days < 0
  end

  def class_of_item(item)
    return 'today' if item.closed_today?
    return 'closed' if item.closed?
    return 'delayed' if item.delayed?
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
end
