require 'test_helper'

class ConvocationsControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "an user logged in" do
    setup do
      login
      @uniform = Uniform.make
      @fireman = make_fireman_with_grades(:station => @station)      
    end
    
    context "requesting index" do
      setup do
        get :index
      end
    
      should_respond_with(:success)
      should_render_template("index")
      should_render_with_layout("back")
      
      should_assign_to(:convocations)
    end
    
    context "requesting a non existing convocation" do
      setup do
        get :show, :id => 2458437589
      end
      
      should_respond_with(:redirect)
      should_redirect_to(":index") { convocations_path }

      should_set_the_flash(:error)
    end
        
    context "requesting GET :new" do
      setup do
        get :new
      end
    
      should_respond_with(:success)
      should_render_template("new")
      should_render_with_layout("back")
    end
    
    context "requesting POST with bad data" do
      setup do
        post :create, :convocation => {:title => '', :date => '', :place => '', :uniform_id => '', :fireman_ids => []}
      end
    
      should_respond_with(:success)
      should_render_template("new")
      should_render_with_layout("back")
      
      should_not_change("number of convocations") { Convocation.count }
    end
    
    context "requesting POST with good data" do
      setup do
        post :create, :convocation => {:title => "Test", :date => I18n.localize(2.weeks.from_now), :place => "Test lieu",
                                       :fireman_ids => [@fireman.id.to_s], :uniform_id => @uniform.id.to_s}
      end
    
      should_respond_with(:redirect)
      should_redirect_to("convocation") { convocation_path(assigns(:convocation)) }
      
      should_change("number of convocations", :by => 1) { Convocation.count }
      should_set_the_flash(:success)
    end
    
    context "with an existing convocation not editable" do
      setup do
        @convocation = make_convocation_with_firemen(:station => @station)
        Convocation.any_instance.stubs(:editable?).returns(false)        
      end
      
      context "requesting GET :edit" do
        setup do
          get :edit, :id => @convocation.id
        end
  
        should_respond_with(:redirect)
        should_redirect_to("convocation") { convocation_path(assigns(:convocation)) }
        
        should_set_the_flash(:error)
      end
      
      context "requesting PUT with good data" do
        setup do
          put :update, :id => @convocation.id, :convocation => {:title => "Test", :date => I18n.localize(2.weeks.from_now), :place => "Test lieu",
                                                                :fireman_ids => [@fireman.id.to_s], :uniform_id => @uniform.id.to_s}
        end
  
        should_respond_with(:redirect)
        should_redirect_to("convocation") { convocation_path(assigns(:convocation)) }

        should_set_the_flash(:error)
      end      
    end
    
    context "with an existing convocation" do
      setup do
        @convocation = make_convocation_with_firemen(:station => @station)
      end
      
      context "requesting GET on existing convocation" do
        setup do
          get :show, :id => @convocation.id
        end
        
        should_respond_with(:success)
        should_render_template("show")
        should_render_with_layout("back")
        
        should_assign_to(:convocation)
      end
      
      context "requesting GET on existing convocation with PDF format" do
        setup do
          @request.env["SERVER_PROTOCOL"] = "http"
          get :show, :id => @convocation.id, :format => 'pdf'
        end
        
        should_respond_with(:success)
        should_render_template("show")
        should "send a file" do
          send_file_to_disk(@response.body, "convocation.pdf")
        end
      end      
      
      context "requesting GET :edit" do
        setup do
          get :edit, :id => @convocation.id
        end
  
        should_respond_with(:success)
        should_render_template("edit")
        should_render_with_layout("back")
      end
      
      context "requesting PUT with bad data" do
        setup do
          put :update, :id => @convocation.id, :convocation => {:title => "", :date => I18n.localize(2.weeks.from_now), :place => "",
                                                                :fireman_ids => [@fireman.id.to_s], :uniform_id => @uniform.id.to_s}
        end
  
        should_respond_with(:success)
        should_render_template("edit")
        should_render_with_layout("back")
      end
      
      context "requesting PUT with good data" do
        setup do
          put :update, :id => @convocation.id, :convocation => {:title => "Test", :date => I18n.localize(2.weeks.from_now), :place => "Test lieu",
                                                                :fireman_ids => [@fireman.id.to_s], :uniform_id => @uniform.id.to_s}
        end
  
        should_respond_with(:redirect)
        should_redirect_to("convocation") { convocation_path(assigns(:convocation)) }

        should_set_the_flash(:success)
      end
      
      context "requesting DELETE :destroy" do
        setup do
          delete :destroy, :id => @convocation.id
        end
        
        should_redirect_to("convocations list") { convocations_path }
        
        should_change("number of convocations", :by => -1) { Convocation.count }
        should_set_the_flash(:success)
      end    
    end
  end
end
