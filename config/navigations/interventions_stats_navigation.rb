# -*- encoding : utf-8 -*-
SimpleNavigation::Configuration.run do |navigation|

  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item(:by_type, 'Par type', interventions_stats_path((@current_year || Date.today.year), "by_type"), :highlights_on => /^\/interventions\/stats\/(\d+)\/by_type/)
    primary.item(:by_month, 'Par mois', interventions_stats_path((@current_year || Date.today.year), "by_month"), :highlights_on => /^\/interventions\/stats\/(\d+)\/by_month/)
    primary.item(:by_hour, 'Par heure', '#')
    primary.item(:by_place, 'Par commune', '#')
    primary.item(:by_vehicle, 'Par véhicule', '#')
    primary.item(:by_specification, 'Par spéc', '#')
  end

end
