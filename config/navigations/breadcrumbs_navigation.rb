SimpleNavigation::Configuration.run do |navigation|

  navigation.selected_class = 'active'

  # Define the primary navigation
  navigation.items do |primary|
    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    #
    primary.item(:user_account, icon_label_text('glyphicon glyphicon-info-sign', current_user.email)) do |user_account|
      user_account.item(:logout, 'Déconnexion', logout_path)
      user_account.item(:account, 'Mon compte', profile_path, :highlights_on => /^\/account/)
    end

    primary.item(:home, icon_label_text('glyphicon glyphicon-home', 'Accueil')) do |home|
      home.item(:dashboard, 'Le standard', root_back_path, :highlights_on => /^\/$/)
      home.item(:daybooks, 'Main courante', daybooks_path, :highlights_on => /^\/daybooks/)
      home.item(:messages, 'Messages', messages_path, :highlights_on => /^\/messages/)
    end

    primary.item(:admin, icon_label_text('glyphicon glyphicon-cog', 'Administration'), :if => Proc.new { current_user.owner? }) do |admin|
      admin.item(:account, 'Compte', edit_account_path, :highlights_on => /^\/account/)
      admin.item(:users, 'Utilisateurs', users_path, :highlights_on => /^\/users/)
      admin.item(:groups, 'Groupes', groups_path, :highlights_on => /^\/groups/)
    end

    primary.item(:personnel, icon_label_text('glyphicon glyphicon-user', 'Personnel')) do |personnel|
      personnel.item(:firemen, 'Hommes', firemen_path, :highlights_on => /^\/firemen/) do |firemen|
        firemen.item(:resigned, 'Radiés', resigned_firemen_path, :highlights_on => /^\/firemen\/resigned/)
      end
      personnel.item(:planning, 'Disponibilités', planning_path("general"), :highlights_on => /^\/plannings/)
      personnel.item(:convocations, 'Convocations', convocations_path, :highlights_on => /^\/convocations/)
      personnel.item(:trainings, 'Formations', trainings_path, :highlights_on => /^\/trainings/)
      personnel.item(:uniforms, 'Tenues', uniforms_path, :highlights_on => /^\/uniforms/)
    end

    primary.item(:materiel, icon_label_text('glyphicon glyphicon-list', 'Matériel')) do |materiel|
      materiel.item(:check_lists, 'Listes', check_lists_path, :highlights_on => /^\/check_lists/)
      materiel.item(:expirings, 'Expiration', expirings_items_path, :highlights_on => /^\/items\/expirings/)
      materiel.item(:vehicles, 'Véhicules', vehicles_path, :highlights_on => /^\/vehicles/) do |vehicles|
        vehicles.item(:delisted, 'Radiés', delisted_vehicles_path, :highlights_on => /^\/vehicles\/delisted/)
      end
    end

    primary.item(:intervention, icon_label_text('glyphicon glyphicon-fire', 'Interventions')) do |intervention|
      intervention.item(:interventions_list, 'Liste', interventions_path, :highlights_on => /^\/interventions\/?((\d).*|new|\?page=(\d).*)?$/)
      intervention.item(:interventions_stats, 'Statistiques', interventions_stats_path((@current_year || Date.today.year), "by_type"), :highlights_on => /^\/interventions\/stats/)

      intervention.item(:interventions_roles, 'Rôles', intervention_roles_path, :highlights_on => /^\/intervention_roles/)
    end
  end
end
