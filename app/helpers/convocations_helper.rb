module ConvocationsHelper
  
  def display_presence(status)
    presence = @presence.find { |i| i[:status].to_i == status }
    ratio = (presence[:presents].to_i*100)/presence[:total].to_i
    result = "#{presence[:total]} convoqués / #{presence[:presents]} présents / #{presence[:missings]} absents (#{ratio} % présents)"
  end
  
end
