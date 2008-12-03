
class Time
  def fecha
    self.strftime("%d/%m/%Y")
  end

  def to_db
    self.strftime("%Y%m%d")
  end
end