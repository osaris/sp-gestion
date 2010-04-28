# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|  
  # Specify a custom renderer if needed. 
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # navigation.renderer = Your::Custom::Renderer
  
  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  navigation.selected_class = 'active'
  
  # Normally only the current sub menu is renderedwhen render_navigation is called
  # setting this to true render all submenus which is useful for javascript
  # driven hovering menus like the jquery superfish plugin
  # navigation.render_all_levels = true
  
  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation
  navigation.items do |primary|
    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    #
    primary.item(:home, 'Accueil', root_back_path) do |home|
      home.item(:dashboard, 'Le standard', root_back_path)
      home.item(:messages, 'Messages', messages_path)
      
      home.auto_highlight = false
      home.dom_class = 'subnav'
    end
    
    primary.item(:personnel, 'Personnel', firemen_path) do |personnel|
      personnel.item(:firemen, 'Hommes', firemen_path)
      personnel.item(:convocations, 'Convocations', convocations_path)
      
      personnel.item(:uniforms, 'Tenues', uniforms_path, :class => 'right')
      
      personnel.auto_highlight = false
      personnel.dom_class = 'subnav'
    end

    primary.item(:materiel, 'Matériel', check_lists_path) do |materiel|
      materiel.item(:check_lists, 'Listes', check_lists_path)
      materiel.item(:expirings, 'Expiration', expirings_items_path)

      materiel.auto_highlight = false
      materiel.dom_class = 'subnav'
    end
    
    primary.item(:intervention, 'Interventions', interventions_path) do |intervention|
      intervention.item(:interventions_list, 'Liste', interventions_path)
      intervention.item(:interventions_stats, 'Statistiques', stats_interventions_path)

      intervention.item(:vehicles, 'Véhicules', vehicles_path, :class => 'right')

      intervention.auto_highlight = false
      intervention.dom_class = 'subnav'
    end
    
    primary.dom_id = 'mainnav'
    
    # You can also specify a condition-proc that needs to be fullfilled to display an item.
    # Conditions are part of the options. They are evaluated in the context of the views,
    # thus you can use all the methods and vars you have available in the views.
    # primary.item :key_3, 'Admin', url, :class => 'special', :if => Proc.new { current_user.admin? }
    # primary.item :key_4, 'Account', url, :unless => Proc.new { logged_in? }

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    # primary.dom_id = 'menu-id'
    # primary.dom_class = 'menu-class'
    
    # You can turn off auto highlighting for a specific level
    # primary.auto_highlight = false
  
  end
  
end