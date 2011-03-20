# -*- encoding : utf-8 -*-
SimpleNavigation::Configuration.run do |navigation|

  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item(:confirmations, 'Activation du compte', '#', :highlights_on => /^\/confirmations/)
  end

end
