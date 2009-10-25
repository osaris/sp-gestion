# override default TabsOnRails builder

class MenuTabBuilder < TabsOnRails::Tabs::Builder
  
  def tab_for(tab, name, options, item_options = {})
    css_class = []
    css_class << item_options[:class]
    css_class << (current_tab?(tab) ? "active" : "")
    
    item_options[:class] =  css_class * ' '
    @context.content_tag(:li, item_options) do
      @context.link_to(name, options)
    end
  end
  
  def open_tabs
  end

  def close_tabs
  end
end