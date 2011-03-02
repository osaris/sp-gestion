# -*- encoding : utf-8 -*-
module ConvocationsHelper

  def display_stats_presence(status)
    presence = @presence.find { |line| line[:status].to_i == status }
    ratio = (presence[:presents].to_i*100)/presence[:total].to_i
    result = "#{presence[:total].to_i} convoqué(s) / #{presence[:presents].to_i} présent(s) / #{presence[:missings].to_i} absent(s) (#{ratio} % présents)"
  end

  def distance_to_next_email_send(last_email_sent_at)
    (last_email_sent_at + 3600 - Time.now).to_i/60
  end

end
