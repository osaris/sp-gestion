require 'test_helper'

class CheckListsControllerTest < ActionController::TestCase
  
  setup(:activate_authlogic)

  context "an user logged in" do
    setup do
      login
    end

    context "requesting index" do
      setup do
        get :index
      end

      should_respond_with(:success)
      should_render_template("index")
      should_render_with_layout("back")

      should_assign_to(:check_lists)
    end

    context "requesting a non existing check-list" do
      setup do
        get :show, :id => rand(10)
      end

      should_respond_with(:redirect)
      should_redirect_to(":index") { check_lists_path }

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
        post :create, :check_list => {:title => ''}
      end

      should_respond_with(:success)
      should_render_template("new")
      should_render_with_layout("back")

      should_not_change("number of check_lists") { CheckList.count }
    end

    context "requesting POST with good data" do
      setup do
        post :create, :check_list => CheckList.plan
      end

      should_respond_with(:redirect)
      should_redirect_to("check_list") { check_list_path(assigns(:check_list)) }

      should_assign_to(:check_list)
      should_change("number of check_list", :by => 1) { CheckList.count }
      should_set_the_flash(:success)
    end

    context "with an existing check_list" do
      setup do
        @check_list = @station.check_lists.make
      end

      context "requesting GET on existing check_list" do
        setup do
          get :show, :id => @check_list.id
        end

        should_respond_with(:success)
        should_render_template("show")
        should_render_with_layout("back")
      end

      context "requesting GET on existing check_list with PDF format" do
        setup do
          @request.env["SERVER_PROTOCOL"] = "http"
          get :show, :id => @check_list.id, :format => 'pdf'
        end

        should_respond_with(:success)
        should_render_template("show")
        should "send a file" do
          send_file_to_disk(@response.body, "check_list.pdf")
        end
      end

      context "requesting GET :edit" do
        setup do
          get :edit, :id => @check_list.id
        end

        should_respond_with(:success)
        should_render_template("edit")
        should_render_with_layout("back")
      end

      context "requesting PUT with bad data" do
        setup do
          put :update, :id => @check_list.id, :check_list => {:title => ''}
        end

        should_respond_with(:success)
        should_render_template("edit")
        should_render_with_layout("back")
      end

      context "requesting PUT with good data" do
        setup do
          put :update, :id => @check_list.id, :check_list => CheckList.plan
        end

        should_respond_with(:redirect)
        should_redirect_to("check_list") { check_list_path(assigns(:check_list)) }
        should_set_the_flash(:success)
      end

      context "requesting DELETE :destroy" do
        setup do
          delete :destroy, :id => @check_list.id
        end

        should_redirect_to("check_lists list") { check_lists_path }

        should_change("number of check_lists", :by => -1) { CheckList.count }
        should_set_the_flash(:success)
      end

      context "requesting POST :copy" do
        setup do
          post :copy, :id => @check_list.id
        end
        
        should_redirect_to("check_lists list") { check_lists_path }

        should_change("number of check_lists", :by => 1) { CheckList.count }
        should_set_the_flash(:success)
      end
    end
  end
end
