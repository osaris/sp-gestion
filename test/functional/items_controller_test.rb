require 'test_helper'

class ItemsControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "an user logged in with an existing check_list" do
    setup do
      login
      @check_list = @station.check_lists.make!
    end

    context "requesting GET :expirings" do
      setup do
        get :expirings
      end

      should respond_with(:success)
      should render_template("expirings")
      should render_with_layout("back")

      should assign_to(:items)
      should set_session(:back_path) { expirings_items_path }
    end

    context "requesting GET :expirings with PDF format" do
      setup do
        @request.env["SERVER_PROTOCOL"] = "http"
        get :expirings, :format => 'pdf'
      end

      should respond_with(:success)
      should render_template("expirings")
      should "send a file" do
        send_file_to_disk(@response.body, "check_list_expiration.pdf")
      end
    end

    context "requesting GET :edit for a non existing check_list" do
      setup do
        get :edit, :check_list_id => -1, :id => -1
      end

      should respond_with(:redirect)
      should redirect_to(":index") { check_lists_path }

      should set_the_flash.level(:error)
    end

    context "requesting GET :edit for a non existing item on an existing check_list" do
      setup do
        get :edit, :check_list_id => @check_list.id, :id => -1
      end

      should respond_with(:redirect)
      should redirect_to(":index") { check_list_path(@check_list) }

      should set_the_flash.level(:error)
    end

    context "requesting GET :new" do
      setup do
        get :new, :check_list_id => @check_list.id
      end

      should respond_with(:success)
      should render_template("new")
      should render_with_layout("back")
    end

    context "requesting POST :create with bad data" do
      setup do
        post :create, :check_list_id => @check_list.id, :item => {:title => ''}
      end

      should respond_with(:success)
      should render_template("new")
      should render_with_layout("back")
    end

    context "requesting POST :create with good data" do
      setup do
        post :create, :check_list_id => @check_list.id, :item => {:title => 'Test', :quantity => '1'}
      end

      should respond_with(:redirect)
      should redirect_to("check_list") { check_list_path(assigns(:check_list)) }

      should assign_to(:check_list)
      should set_the_flash.level(:success)
    end

    context "with an existing item" do
      setup do
        @item = @check_list.items.make!
      end

      context "requesting GET :edit" do
        setup do
          get :edit, :check_list_id => @check_list.id, :id => @item.id
        end

        should respond_with(:success)
        should render_template("edit")
        should render_with_layout("back")
      end

      context "requesting PUT :update with bad data" do
        setup do
          put :update, :check_list_id => @check_list.id, :id => @item.id, :item => {:title => '', :quantity => '1'}
        end

        should respond_with(:success)
        should render_template("edit")
        should render_with_layout("back")
      end

      context "requesting PUT :update with good data" do
        setup do
          put :update, :check_list_id => @check_list.id, :id => @item.id, :item => {:title => 'Test', :quantity => '1'}
        end

        should respond_with(:redirect)
        should redirect_to("check_list") { check_list_path(assigns(:check_list)) }

        should set_the_flash.level(:success)
      end

      context "requesting PUT :update with good data and back_path set to expiring" do
        setup do
          session[:back_path] = expirings_items_path
          put :update, :check_list_id => @check_list.id, :id => @item.id, :item => {:title => 'Test', :quantity => '1'}
        end

        should respond_with(:redirect)
        should redirect_to("expirings") { expirings_items_path }

        should set_the_flash.level(:success)
      end

      context "requesting DELETE :destroy" do
        setup do
          delete :destroy, :check_list_id => @check_list.id, :id => @item.id
        end

        should redirect_to("check_list") { check_list_path(assigns(:check_list)) }

        should set_the_flash.level(:success)
      end

      context "requesting DELETE :destroy and back_path set to expiring" do
        setup do
          session[:back_path] = expirings_items_path
          delete :destroy, :check_list_id => @check_list.id, :id => @item.id
        end

        should respond_with(:redirect)
        should redirect_to("expirings") { expirings_items_path }

        should set_the_flash.level(:success)
      end
    end
  end
end