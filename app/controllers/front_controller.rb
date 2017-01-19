class FrontController < ApplicationController
  layout('front')
  force_ssl if: :ssl_configured?

  def ssl_configured?
    Rails.env.production?
  end  
end
