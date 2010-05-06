# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def flash_helper
    [:success, :warning, :error].map { |type| content_tag(:p, flash[type], :class => "message #{type}") if flash[type] }
  end
  
  def img_grade(grade)
    image_tag("back/grades/#{grade}.png", :alt => Grade::GRADE.index(grade))
  end

  def context_login_navigation(controller_name)
    if controller_name == "confirmations"
      return "confirmation"
    elsif controller_name == "email_confirmations"
      return "email_confirmation"
    else
      return "login"
    end
  end
  
  def l!(object, options = {})
    begin
      I18n.localize(object, options)
    rescue
      return ""
    end
  end
  
end
