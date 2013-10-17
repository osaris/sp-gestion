require 'spec_helper'

describe "404 Page Not Found" do

  let(:station) { Station.make! }

  context "on main domain" do
    before(:each) do
      host!("www.test.local")
      get "/548335"
    end

    it "should redirect to homepage" do
      assert_redirected_to("http://www.test.local/home")
    end
  end

  context "on a subdomain" do
    before(:each) do
      host!("#{station.url}.test.local")
      get "/3485943"
    end

    it "should redirect to login page" do
      assert_redirected_to("http://#{station.url}.test.local/login")
    end
  end

  context "on a non existing subdomain" do
    before(:each) do
      host!("subdomain.test.local")
      get "/3475843"
    end

    it "should redirect to homepage" do
      assert_redirected_to("http://www.test.local/home")
    end
  end
end