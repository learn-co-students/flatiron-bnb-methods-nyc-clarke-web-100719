class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :not_own_listing, :available, :checkin_before_checkout


  def duration
    (checkout - checkin).to_i
  end
  
  def total_price
    listing.price * duration
  end

  private

  def not_own_listing
    if listing.host === guest
      errors.add(:guest, "can't be the host")
    end
  end

  def available
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:guest, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

  def checkin_before_checkout
    if checkout && checkin && checkout <= checkin
      errors.add(:guest, "Your checkin date needs to be before your checkout!")
    end
  end


end
