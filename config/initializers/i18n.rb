I18n.default_locale = :fr
I18n.exception_handler = :missing_translations_handler

module I18n
  class << self
    def missing_translations_handler(exception, locale, key, options)
      case Rails.env
      when "development"
        puts "[i18n][ERROR] %s" % exception.message
        return exception.message
      when "test"
        raise exception
      when "production"
        if MissingTranslationData === exception
          notify_errornot(exception)
          return exception.message
        else
          raise exception
        end
      end
    end
  end
end