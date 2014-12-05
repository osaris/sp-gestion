module FiremenHelper

  def grade_and_name(fireman)
    result = ""
    if !(fireman.grade.blank?)
      result += Grade::GRADE.key(fireman.grade) + " "
    end
    result += fireman.firstname + " " + fireman.lastname
    result
  end

  def active_accordion(fireman)
    # if grade is set, we use it for default category
    if !fireman.current_grade.blank?
      category = Grade::GRADE_CATEGORY_MATCH[fireman.current_grade.kind]
    elsif fireman.status == Fireman::STATUS['JSP']
      category = Grade::GRADE_CATEGORY['JSP']
    end

    case category
      when Grade::GRADE_CATEGORY['Médecin']
        result = 0
      when Grade::GRADE_CATEGORY['Infirmier']
        result = 1
      when Grade::GRADE_CATEGORY['Officier']
        result = 2
      when Grade::GRADE_CATEGORY['Sous-officier']
        result = 3
      when Grade::GRADE_CATEGORY['Homme du rang']
        result = 4
      when Grade::GRADE_CATEGORY['JSP']
        result = 5
      else
        result = 4
    end
    result
  end
end
