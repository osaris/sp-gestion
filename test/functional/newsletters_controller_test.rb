require File.dirname(__FILE__) + '/../test_helper'

class NewslettersControllerTest < ActionController::TestCase

  context "requesting POST :create with bad data" do
    setup do
      post :create, :email => "test"
    end
    
    should_respond_with(:success)
    should_render_template("pages/home")
    should_render_with_layout("front")   
    
    should_not_change("number of newsletters") { Newsletter.count }
  end

  context "requesting POST :create with good data" do
    setup do
      post :create, :newsletter => {:email => "test@test.com"}
    end

    should_respond_with(:success)
    should_render_template("pages/home")
    should_render_with_layout("front")
    
    should_change("number of newsletters", :by => 1) { Newsletter.count }
  end
  
  context "requesting GET :activate with bad data" do
    setup do
      get :activate, :id => 123
    end
    
    should_redirect_to("homepage") { home_page_path }
  end
  
  context "requesting GET :activate with good data" do
    setup do
      @nl = Newsletter.make
      get :activate, :id => @nl.activation_key
      @nl.reload
    end
    
    should_respond_with(:success)
    should_render_template("pages/home")
    should_render_with_layout("front")    
    
    should "have activated newsletter" do
      assert_equal("", @nl.activation_key)
    end
  end
  

end