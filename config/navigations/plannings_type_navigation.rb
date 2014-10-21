# -*- encoding : utf-8 -*-
SimpleNavigation::Configuration.run do |navigation|

  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item(:general,
                 'Général',
                 plannings_type_path("general"),
                 :highlights_on => /^\/plannings\/type\/general/)
    primary.item(:by_grade,
                 'Par grade',
                 plannings_type_path("by_grade"),
                 :highlights_on => /^\/plannings\/type\/by_grade/)
    primary.item(:by_formation,
                 'Par formation',
                 plannings_type_path("by_formation"),
                 :highlights_on => /^\/plannings\/type\/by_formation/)

    primary.dom_class = 'nav nav-tabs'
  end

end
