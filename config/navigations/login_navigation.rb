SimpleNavigation::Configuration.run do |navigation|  

  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item(:user_sessions, 'Connexion', login_path)
    primary.item(:password_resets, 'Mot de passe perdu', new_password_reset_path)
  end
  
end