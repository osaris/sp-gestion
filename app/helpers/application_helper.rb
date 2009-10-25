# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def flash_helper
    [:notice, :warning, :error].map { |f| content_tag(:p, flash[f], :class => "message #{f}") if flash[f] }
  end
  
end
