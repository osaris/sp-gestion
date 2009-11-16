module FiremenHelper
  
  def js_for_birthday
    javascript_tag("
      $(function() {
        $('#fireman_birthday').datepicker($.datepicker.regional['fr']);
        $('#fireman_birthday').datepicker('option', $.extend({showMonthAfterYear: false, changeMonth: true, changeYear: true, 
                                           minDate : '-80y', maxDate: '-12y', yearRange : '-80:0'}));
      });
    ")
  end
  
  def js_for_grade_date
    javascript_tag("
      $(function() {
        $('input[name*=date]').datepicker($.datepicker.regional['fr']);
        $('input[name*=date]').datepicker('option', $.extend({showMonthAfterYear: false, changeMonth: true, changeYear: true, 
                                                              minDate : '-80y', maxDate: '+1y', yearRange : '-80:1'}));
      });
    ")
  end
  
  def js_for_status
    javascript_tag("
      $(function() {
        $('#fireman_status').change(function() {
          if ($(this).val() == 1)
            $('#grades').hide();
          else
            $('#grades').show();
        });
      });
    ")
  end
  
  def style_for_grade(fireman)
    fireman.status == 1 ? 'display:none;' : ''
  end
  
end