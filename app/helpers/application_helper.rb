# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def flash_helper
    [:notice, :warning, :error].map { |f| content_tag(:p, flash[f], :class => "message #{f}") if flash[f] }
  end
  
  def img_grade(fireman)
    if fireman.status == Fireman::STATUS['Actif']
      image_tag("back/grades/#{fireman.grade}.png", :alt => Grade::GRADE.index(fireman.grade))
    end
  end
  
end
