# -*- encoding : utf-8 -*-
SimpleNavigation::Configuration.run do |navigation|

  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item(:general,
                 'Général',
                 planning_path("general"),
                 :highlights_on => /^\/plannings\/general/)
    primary.item(:by_grade,
                 'Par grade',
                 planning_path("by_grade"),
                 :highlights_on => /^\/plannings\/by_grade/)
    primary.item(:by_training,
                 'Par formation',
                 planning_path("by_training"),
                 :highlights_on => /^\/plannings\/by_training/)

    primary.dom_class = 'nav nav-tabs'
  end
end
