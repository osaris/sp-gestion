# -*- encoding : utf-8 -*-
SimpleNavigation::Configuration.run do |navigation|

  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item(:user_sessions, 'Connexion', login_path, :highlights_on => /^\/login/)
    primary.item(:password_resets, 'Mot de passe perdu', new_password_reset_path, :highlights_on => /^\/password_resets/)
  end

end
