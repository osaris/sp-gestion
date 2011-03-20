# -*- encoding : utf-8 -*-
SimpleNavigation::Configuration.run do |navigation|

  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item(:email_confirmations, "Changement de l'adresse email", '#', :highlights_on => /^\/email_confirmations/)
  end

end
