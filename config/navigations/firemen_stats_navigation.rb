SimpleNavigation::Configuration.run do |navigation|

  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item(:interventions_by_role,
                 'Interventions par rôle',
                 firemen_stats_path(@fireman, params[:year], "interventions_by_role"),
                 :highlights_on => /^\/firemen\/(\d+)\/stats\/(\d+)\/interventions_by_role/)
    primary.item(:convocations,
                 'Convocations',
                 firemen_stats_path(@fireman, params[:year], "convocations"),
                 :highlights_on => /^\/firemen\/(\d+)\/stats\/(\d+)\/convocations/)

    primary.dom_class = 'nav nav-tabs'
  end

end
