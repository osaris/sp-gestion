module ConvocationsHelper
  
  def display_stats_presence(status)
    presence = @presence.find { |line| line[:status].to_i == status }
    ratio = (presence[:presents].to_i*100)/presence[:total].to_i
    result = "#{presence[:total]} convoqué(s) / #{presence[:presents]} présent(s) / #{presence[:missings]} absent(s) (#{ratio} % présents)"
  end
  
end
