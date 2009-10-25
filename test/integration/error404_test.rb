require 'test_helper'

class Error404Test < ActionController::IntegrationTest

  context "a request to a non existing page on main domain" do
    setup do
      host!("www.test.local")
      get "/548335"
    end
  
    should_redirect_to("front homepage") { "http://www.test.local" }
  end
  
  context "a request to a non existing page on a subdomain" do
    setup do
      @company = Station.make()
      host!("#{@company.url}.test.local")
      get "/3485943"
    end
  
    should_redirect_to("back login page") { "http://#{@company.url}.test.local/login" }
  end

  context "a request to a non existing page on a non existing subdomain" do
    setup do
      host!("subdomain.test.local")
      get "/3475843"
    end
  
    should_redirect_to("front homepage") { "http://www.test.local" }
  end

end
