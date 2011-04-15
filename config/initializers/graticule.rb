# -*- encoding : utf-8 -*-
Geocode.geocoder = Graticule.service(:google).new(GOOGLE_APPLICATION_ID)

# Monkey patch Google geocoder to avoid UTF-8 encoding problems

module Graticule
  module Geocoder
    class Google < Base

      private

      def parse_response(response)
        result = response.placemarks.first
        Location.new(
          :latitude    => result.latitude,
          :longitude   => result.longitude,
          :street      => "", # ugly hack
          :locality    => result.locality,
          :region      => result.region,
          :postal_code => result.postal_code,
          :country     => result.country,
          :precision   => result.precision
        )
      end

    end
  end
end