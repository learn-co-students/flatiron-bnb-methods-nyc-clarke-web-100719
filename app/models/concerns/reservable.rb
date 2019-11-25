module Reservable
    module InstanceMethods
        def openings(start_date, end_date)
            self.listings.merge(Listing.available(start_date, end_date))
        end
        def reservations
            listings.map { |listing| listing.reservations }.flatten
        end

        def ratio_reservations_to_listings
            if listings.count > 0
                self.reservations.count.to_f / self.listings.count.to_f
            else 
                0
            end
        end
    end
    
    module ClassMethods
        def highest_ratio_res_to_listings
            self.all.max_by { |location| location.ratio_reservations_to_listings }
        end
    
        def most_res
            self.all.max_by { |location| location.reservations.count }
        end    
    end
end