# -*- encoding : utf-8 -*-
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def flash_helper
    msg = "".html_safe
    [:success, :warning, :error].map { |type| msg << content_tag(:p, flash[type], :class => "message #{type}") if flash[type] }
    msg
  end

  def img_grade(grade)
    image_tag("back/grades/#{grade}.png", :alt => Grade::GRADE.key(grade), :class => 'grade')
  end

  def context_login_navigation(controller_name)
    if controller_name == "confirmations"
      return "confirmation"
    elsif controller_name == "email_confirmations"
      return "email_confirmation"
    else
      return "login"
    end
  end

  def l!(object, options = {})
    begin
      I18n.localize(object, options)
    rescue
      return ""
    end
  end

  def error_message_on(object, method, *args)
    options = {:tag => 'span'}.merge(args.extract_options!.symbolize_keys)
    prepend_text = args[0] || options[:prepend_text] || "<span>&uarr;&nbsp;</span>"
    append_text =  args[1] || options[:append_text]  || ''
    css_class = (args[2] || options[:css_class] || '') + ' formError'
    if (obj = (object.respond_to?(:errors) ? object : instance_variable_get("@#{object}"))) \
      && (errors = obj.errors[method]) \
      && (errors.size > 0)
      content_tag(options[:tag], "#{prepend_text}#{errors.first.to_s}#{append_text}".html_safe, :class => css_class)
    else
      ''
    end
  end

end
