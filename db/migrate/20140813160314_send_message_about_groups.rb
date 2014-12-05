class SendMessageAboutGroups < ActiveRecord::Migration

  MESSAGE_TITLE = 'Gestion des droits et des groupes'

  def up
    Station.find_each(:batch_size => 50) do |s|
      s.owner.messages.create(:title => MESSAGE_TITLE,
                              :body => <<EOF
<p>Bonjour,</p>
<p>Dès aujourd'hui vous avez la possibilité de gérer les droits des utilisateurs
de votre compte SP-Gestion. Pour celà vous devez créer des groupes
(menu "Administration > Groupes") et spécifier les droits de ce groupe ainsi
que les utilisateurs membres de ce groupe.</p>
<p>Un utilisateur ne peut être membre que d'un seul groupe et les utilisateurs
qui n'appartiennent pas à un groupe ont les mêmes droits qu'aujourd'hui.</p>
<p>L'équipe SP-Gestion (<a href="mailto:contact@sp-gestion.fr">contact@sp-gestion.fr</a>)</p>
<p>PS : il est possible de consulter ce message à tout moment via le menu "Accueil > Messages".</p>
EOF
      )
    end
  end

  def down
    Message.where(:title => MESSAGE_TITLE).delete_all
  end
end
