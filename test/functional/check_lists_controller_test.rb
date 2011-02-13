require 'test_helper'

class CheckListsControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "an user logged in" do
    setup do
      login
    end

    context "requesting GET :index" do
      setup do
        get :index
      end

      should respond_with(:success)
      should render_template("index")
      should render_with_layout("back")

      should assign_to(:check_lists)
    end

    context "requesting GET :show for a non existing check-list" do
      setup do
        get :show, :id => -1
      end

      should respond_with(:redirect)
      should redirect_to(":index") { check_lists_path }

      should set_the_flash.level(:error)
    end

    context "requesting GET :new" do
      setup do
        get :new
      end

      should respond_with(:success)
      should render_template("new")
      should render_with_layout("back")
    end

    context "requesting POST :create with bad data" do
      setup do
        post :create, :check_list => {:title => ''}
      end

      should respond_with(:success)
      should render_template("new")
      should render_with_layout("back")
    end

    context "requesting POST :create with good data" do
      setup do
        post :create, :check_list => plan(CheckList.make)
      end

      should respond_with(:redirect)
      should redirect_to("check_list") { check_list_path(assigns(:check_list)) }

      should assign_to(:check_list)
      should set_the_flash.level(:success)
    end

    context "with an existing check_list" do
      setup do
        @check_list = @station.check_lists.make!
      end

      context "requesting GET :show on existing check_list" do
        setup do
          get :show, :id => @check_list.id
        end

        should respond_with(:success)
        should render_template("show")
        should render_with_layout("back")
      end

      context "requesting GET :show on existing check_list with PDF format" do
        setup do
          @request.env["SERVER_PROTOCOL"] = "http"
          get :show, :id => @check_list.id, :format => 'pdf'
        end

        should respond_with(:success)
        should render_template("show")
        should "send a file" do
          send_file_to_disk(@response.body, "check_list.pdf")
        end
      end

      context "requesting GET :edit" do
        setup do
          get :edit, :id => @check_list.id
        end

        should respond_with(:success)
        should render_template("edit")
        should render_with_layout("back")
      end

      context "requesting PUT :update with bad data" do
        setup do
          put :update, :id => @check_list.id, :check_list => {:title => ''}
        end

        should respond_with(:success)
        should render_template("edit")
        should render_with_layout("back")
      end

      context "requesting PUT :update with good data" do
        setup do
          put :update, :id => @check_list.id, :check_list => plan(CheckList.make)
        end

        should respond_with(:redirect)
        should redirect_to("check_list") { check_list_path(assigns(:check_list)) }
        should set_the_flash.level(:success)
      end

      context "requesting DELETE :destroy" do
        setup do
          delete :destroy, :id => @check_list.id
        end

        should redirect_to("check_lists list") { check_lists_path }

        should set_the_flash.level(:success)
      end

      context "requesting POST :copy" do
        setup do
          post :copy, :id => @check_list.id
        end

        should redirect_to("check_lists list") { check_lists_path }

        should set_the_flash.level(:success)
      end
    end
  end
end
