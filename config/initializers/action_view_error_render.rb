module SpanErrorMessages

  def self.included(base)
    ActionView::Base.field_error_proc =
      lambda do |html_tag, instance|
        %(<span class="fieldWithErrors">#{html_tag}</span>)
      end
  end
  
  def error_message_on(object, method, *args)
    options = {:tag => 'span'}.merge(args.extract_options!.symbolize_keys)
    prepend_text = args[0] || options[:prepend_text] || "<span>&uarr;&nbsp;</span>"
    append_text =  args[1] || options[:append_text]  || ''
    css_class = (args[2] || options[:css_class] || '') + ' formError'
    if (
      obj = (object.respond_to?(:errors) ?
      object :
      instance_variable_get("@#{object}"))
    ) && (errors = obj.errors.on(method))
      content_tag(options[:tag], "#{prepend_text}#{errors.is_a?(Array) ?
                  errors.first : errors}#{append_text}", :class => css_class)
    else 
      ''
    end
  end
end

ActionView::Base.send :include, SpanErrorMessages