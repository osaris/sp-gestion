SimpleNavigation::Configuration.run do |navigation|

  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item(:interventions,
                 'Interventions',
                 firemen_stats_path(@fireman, params[:year], "interventions"),
                 :highlights_on => /^\/firemen\/(\d+)\/stats\/(\d+)\/interventions/)
    primary.item(:convocations,
                 'Convocations',
                 firemen_stats_path(@fireman, params[:year], "convocations"),
                 :highlights_on => /^\/firemen\/(\d+)\/stats\/(\d+)\/convocations/)

    primary.dom_class = 'nav nav-tabs'
  end

end
