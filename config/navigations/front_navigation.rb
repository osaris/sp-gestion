SimpleNavigation::Configuration.run do |navigation|

  navigation.selected_class = 'current'

  navigation.items do |primary|
    primary.item(:home, "Accueil", home_path(), :highlights_on => /^\/$|(home)/)
    primary.item(:demo, "Démonstration", "http://cpi-demo.sp-gestion.fr")
    primary.item(:signup, "Inscription", signup_path(), :highlights_on => /signup|stations/, :link => {:class => 'important'})
    primary.item(:blog, "Blog", "http://blog.sp-gestion.fr")
    primary.item(:forum, "Forum", "http://forum.sp-gestion.fr")

    primary.dom_id = 'nav'
  end

end