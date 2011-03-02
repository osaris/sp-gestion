# -*- encoding : utf-8 -*-
require 'test_helper'

class Error404Test < ActionDispatch::IntegrationTest

  context "a request to a non existing page on main domain" do
    setup do
      host!("www.test.local")
      get "/548335"
    end

    # FIXME should be written should redirect_to but shoulda 2.11.3 doesn't like this syntax
    # in integration test
    should "" do
      redirect_to("front homepage") { "http://www.test.local" }
    end
  end

  context "a request to a non existing page on a subdomain" do
    setup do
      @station = Station.make!
      host!("#{@station.url}.test.local")
      get "/3485943"
    end

    should "" do
      redirect_to("back login page") { "http://#{@station.url}.test.local/login" }
    end
  end

  context "a request to a non existing page on a non existing subdomain" do
    setup do
      host!("subdomain.test.local")
      get "/3475843"
    end

    should "" do
      redirect_to("front homepage") { "http://www.test.local" }
    end
  end

end
