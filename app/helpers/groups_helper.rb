module GroupsHelper

  def permission_icon(authorized)
    content_tag(:i, '', :class => 'glyphicon glyphicon-ok') if authorized
  end
end
