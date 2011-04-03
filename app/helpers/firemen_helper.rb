# -*- encoding : utf-8 -*-
module FiremenHelper

  def grade_and_name(fireman)
    result = ""
    result += Grade::GRADE.key(fireman.grade) + " " unless fireman.grade.blank?
    result += fireman.firstname + " " + fireman.lastname
    result
  end

  def style_for_grades(fireman)
    fireman.status == 1 ? "display:none;" : ""
  end

  def class_for_grade(grade)
    grade.date.blank? ? "" : "set"
  end

  def active_accordion(fireman)
    result = 4
    if !fireman.current_grade.blank?
      category = Grade::GRADE_CATEGORY_MATCH[@fireman.current_grade.kind]
      case category
        when Grade::GRADE_CATEGORY['Médecin']
          result = 0
        when Grade::GRADE_CATEGORY['Infirmier']
          result = 1
        when Grade::GRADE_CATEGORY['Officier']
          result = 2
        when Grade::GRADE_CATEGORY['Sous-officier']
          result = 3
        else
          result = 4
      end
    end
    result
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
