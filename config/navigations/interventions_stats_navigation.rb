SimpleNavigation::Configuration.run do |navigation|

  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item(:by_type,
                 'Par type',
                 interventions_stats_path(params[:year], "by_type"),
                 :highlights_on => /^\/interventions\/stats\/(\d+)\/by_type/)
    primary.item(:by_type,
                 'Par sous-type',
                 interventions_stats_path(params[:year], "by_subkind"),
                 :highlights_on => /^\/interventions\/stats\/(\d+)\/by_subkind/)
    primary.item(:by_month,
                 'Par mois',
                 interventions_stats_path(params[:year], "by_month"),
                 :highlights_on => /^\/interventions\/stats\/(\d+)\/by_month/)
    primary.item(:by_hour,
                 'Par heure',
                 interventions_stats_path(params[:year], "by_hour"),
                 :highlights_on => /^\/interventions\/stats\/(\d+)\/by_hour/)
    primary.item(:by_city,
                 'Par ville',
                 interventions_stats_path(params[:year], "by_city"),
                 :highlights_on => /^\/interventions\/stats\/(\d+)\/by_city/)
    primary.item(:by_vehicle,
                 'Par véhicule',
                 interventions_stats_path(params[:year], "by_vehicle"),
                 :highlights_on => /^\/interventions\/stats\/(\d+)\/by_vehicle/)
    primary.item(:map,
                 'Carte',
                 interventions_stats_path(params[:year], "map"),
                 :highlights_on => /^\/interventions\/stats\/(\d+)\/map/)

    primary.dom_class = 'nav nav-tabs'
  end

end
