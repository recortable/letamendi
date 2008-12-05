
class Time

  def self.from_db(encoded)
    Time.utc(encoded[0..3], encoded[4..5], encoded[6..7])
  end

  def fecha
    self.strftime("%d/%m/%Y")
  end

  def to_db
    self.strftime("%Y%m%d")
  end
end