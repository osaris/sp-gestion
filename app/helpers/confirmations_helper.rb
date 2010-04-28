module ConfirmationsHelper
  
  def javascript_for_password_strength
    javascript_tag("
      $(function() {
        $('#user_password').pstrength();
      });
    ")
  end
  
end