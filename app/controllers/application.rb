# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  def normalize(date)
    Time.utc(date.year, date.month, date.day)
  end
  
  def distance(from_time, to_time)
    from_time = normalize(from_time).to_time
    to_time = normalize(to_time).to_time
    distance_in_days = ((((to_time - from_time))/(60 * 60 * 24))).to_i
  end
  
  def show_info(info)
    render :update do |page| 
      page.show_info info
    end
  end

end