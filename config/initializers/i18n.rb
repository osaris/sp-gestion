module I18n
  class << self
    def missing_translations_handler(exception, locale, key, options)
      case RAILS_ENV
      when "development"
        puts "[i18n][ERROR] %s" % exception.message
        return exception.message        
      when "test"
        raise exception        
      when "production"
        if MissingTranslationData === exception
          HoptoadNotifier.notify(:error_message => exception.message,
                                 :backtrace => exception.backtrace)
          return exception.message 
        else
          raise exception
        end        
      end
    end
  end
end