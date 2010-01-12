module FiremenHelper
  
  def js_for_status
    javascript_tag("
      $(function() {
        $('#fireman_status').change(function() {
          if ($(this).val() == 1)
            $('#grades').fadeOut();
          else
            $('#grades').fadeIn();
        });
      });
    ")
  end
  
  def style_for_grades(fireman)
    fireman.status == 1 ? 'display:none;' : ''
  end

  def class_for_grade(grade)
    result = ""
    result += "set " unless grade.date.blank?
    result
  end

  def display_role(fireman)
    roles = []
    roles << "Chef de centre" if fireman.chief
    roles << "Adjoint" if fireman.chief_assistant
    roles << "Fourrier" if fireman.quartermaster

    result = "-"
    result = roles.join(" / ") if roles.size > 0
    result
  end

end