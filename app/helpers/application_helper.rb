# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def flash_helper
    [:notice, :warning, :error].map { |f| content_tag(:p, flash[f], :class => "message #{f}") if flash[f] }
  end
  
  def img_grade(grade)
    image_tag("back/grades/#{grade}.png", :alt => Grade::GRADE.index(grade))
  end
  
end
