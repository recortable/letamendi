ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'videoclub'

  map.connect 'informes/diario/:year/:month/:day', :controller => 'videoclub', :action => 'informe_diario'
  map.connect 'informes/mensual/:year/:month', :controller => 'videoclub', :action => 'informe_mensual'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
