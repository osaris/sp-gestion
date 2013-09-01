# -*- encoding : utf-8 -*-
Geocode.geocoder = (Rails.env.test? ? Graticule.service(:bogus).new :
                                      Graticule.service(:google).new(Rails.configuration.google_application_id))