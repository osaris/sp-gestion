SimpleNavigation::Configuration.run do |navigation|

  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item(:inbox,
                 'Boîte de réception',
                 conversations_path(:mailbox => 'inbox'),
                 :highlights_on => /^\/conversations\?mailbox=inbox/)
    primary.item(:sent,
                 'Messages envoyés',
                 conversations_path(:mailbox => 'sentbox'),
                 :highlights_on => /^\/conversations\?mailbox=sentbox/)
   primary.item(:trash,
                'Corbeille',
                conversations_path(:mailbox => 'trash'),
                :highlights_on => /^\/conversations\?mailbox=trash/)

    primary.dom_class = 'nav nav-tabs'
  end

end
