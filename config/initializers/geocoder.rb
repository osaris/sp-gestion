# -*- encoding : utf-8 -*-
if Rails.env.test?
  Geocoder.configure(:lookup => :test)

  Geocoder::Lookup::Test.set_default_stub(
    [
      {
        'latitude'     => 40.7143528,
        'longitude'    => -74.0059731,
        'address'      => 'New York, NY, USA',
        'state'        => 'New York',
        'state_code'   => 'NY',
        'country'      => 'United States',
        'country_code' => 'US'
      }
    ]
  )
else
  Geocoder.configure(
    :lookup       => :google,
    :timeout      => 1,
    :units        => :km,
    :cache        => Dalli::Client.new,
    :cache_prefix => 'geocoder_'
  )
end
