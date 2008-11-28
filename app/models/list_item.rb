class ListItem < ActiveRecord::Base
  def childs
    ListItem.find_all_by_parent(id)
  end

end
