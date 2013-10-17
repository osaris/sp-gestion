if Rails.env.test?
  Geocoder.configure(:lookup => :test)
else
  Geocoder.configure(
    :lookup       => :google,
    :timeout      => 1,
    :units        => :km,
    :cache        => Dalli::Client.new,
    :cache_prefix => 'geocoder_'
  )
end