class BootstrapBreadcrumbs < SimpleNavigation::Renderer::Base

  def render(item_container)
    content_tag(:ul, prepend + li_tags(item_container).join(join_with).html_safe, { id: item_container.dom_id, class: "#{item_container.dom_class} breadcrumb" })
  end

  protected

  def prepend
    unless options[:root_path].nil?
      content_tag(:li, link_to(content_tag(:i, '', :class => 'glyphicon glyphicon-home'), options[:root_path])) + join_with
    end
  end

  def li_tags(item_container)
    item_container.items.inject([]) do |list, item|
      if item.selected?
        list << content_tag(:li, link_to(item.name, item.url, {method: item.method}.merge(item.html_options.except(:class,:id)))) if item.selected?
        if include_sub_navigation?(item)
          list.concat li_tags(item.sub_navigation)
        end
      end
      list
    end
  end

  def join_with
    @join_with ||= options[:join_with] || '<span class="divider">/</span>'.html_safe
  end
end
