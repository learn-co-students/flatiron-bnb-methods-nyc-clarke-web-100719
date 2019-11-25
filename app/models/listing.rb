class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :description, :price, :neighborhood_id, :title, presence: true
  after_save :set_host_if_host
  before_destroy :unset_host_if_no_listings

  def average_review_rating
    self.reviews.reduce(0) do |sum, review|
      review.rating + sum
    end / reviews.count.to_f
  end

  private 

  def self.available(start_date, end_date)
    if start_date && end_date
  	  start_date = Date.parse(start_date)
  	  end_date = Date.parse(end_date)
      self.select do |listing|
        listing.reservations.each do |res|
          if res.checkin < end_date && res.checkout > start_date
            false
            break
          elsif res.checkout > end_date && res.checkin < end_date
            false
            break
          else
            true
          end
        end
      end
    else
      []
    end
  end

  def unset_host_if_no_listings
    if Listing.where(host: host).where.not(id: id).empty?
      host.update(host: false)
    end
  end

  def set_host_if_host
    unless host.host?
      host.update(host: true)
    end
  end
  
end
