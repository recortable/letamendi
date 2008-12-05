class Pasta < ActiveRecord::Base
  belongs_to :movie
  belongs_to :member

  def closed?
    !open?
  end

  def open?
    closed_at.nil?
  end

  def close
    update_attribute(:closed_at, Time.now.to_db)
  end

  def reopen
    update_attribute(:closed_at, nil)
  end

  def euros
    price.nil? ? '0.00' : (price.to_f / 100).to_s
  end
end
