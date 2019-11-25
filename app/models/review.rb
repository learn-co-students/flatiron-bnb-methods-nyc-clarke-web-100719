class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, presence: true
  validate :reservation_accepted, :checked_out


  private 
  
  def reservation_accepted
    if self.reservation.try(:status) != 'accepted' 
      errors.add(:reservation, "Reservation must be accepted first!")
    end
  end

  def checked_out
    if self.reservation && self.reservation.checkout > Date.today
      errors.add(:reservation, "Reservation must be checked out to write a review!")
    end
  end
end
