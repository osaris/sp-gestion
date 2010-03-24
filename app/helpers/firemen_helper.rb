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
    fireman.status == 1 ? "display:none;" : ""
  end

  def class_for_grade(grade)
    grade.date.blank? ? "" : "set"
  end

  def display_role(fireman)
    roles = []
    roles << "Chef de centre" if fireman.chief
    roles << "Adjoint" if fireman.chief_assistant
    roles << "Fourrier" if fireman.quartermaster

    roles.size > 0 ? roles.join(" / ") : "-"
  end
  
  def display_stats_convocation
    presence = @fireman.stats_convocations
    if presence[:total].to_i > 0
      ratio = (presence[:presents].to_i*100)/presence[:total].to_i
    else
      ratio = 0
    end
    result = "#{presence[:total]} convocation(s) / #{presence[:present]} présence(s) / #{presence[:missing]} absence(s) (#{ratio} % présence)"
  end

end