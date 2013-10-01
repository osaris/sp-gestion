# -*- encoding : utf-8 -*-
module GroupsHelper

  def permission_icon(authorized)
    if authorized
      icon_name = 'icon-ok'
    else
      icon_name = 'icon-remove'
    end
    content_tag(:i, '', :class => icon_name)
  end
end
