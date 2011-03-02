# -*- encoding : utf-8 -*-
module FiremenHelper

  def style_for_grades(fireman)
    fireman.status == 1 ? "display:none;" : ""
  end

  def class_for_grade(grade)
    grade.date.blank? ? "" : "set"
  end

  def display_stats_convocation
    presence = @fireman.stats_convocations
    if presence[:total].to_i > 0
      ratio = (presence[:presents].to_i*100)/presence[:total].to_i
    else
      ratio = 0
    end
    result = "#{presence[:total].to_i} convocation(s) / #{presence[:presents].to_i} présence(s) / #{presence[:missings].to_i} absence(s) (#{ratio} % présence)"
  end

end
