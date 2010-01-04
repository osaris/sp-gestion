class BetaCode < ActiveRecord::Base
  
  belongs_to :user
  
  def after_initialize
    # FIXME can't use self there because of Rails bug
    # https://rails.lighthouseapp.com/projects/8994/tickets/3165-activerecordmissingattributeerror-after-update-to-rails-v-234
    write_attribute(:code, ActiveSupport::SecureRandom.hex(5)) unless read_attribute(:code)
    write_attribute(:used, false) unless read_attribute(:used)
  end
  
end
