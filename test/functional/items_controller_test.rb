require 'test_helper'

class ItemsControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "an user logged in with an existing check_list" do
    setup do
      login
      @check_list = @station.check_lists.make
    end

    context "requesting list of expired items" do
      setup do
        get :expirings
      end

      should_respond_with(:success)
      should_render_template("expirings")
      should_render_with_layout("back")

      should_assign_to(:items)
      should_set_session(:back_path) { expirings_items_path }
    end

    context "requesting list of expired items with PDF format" do
      setup do
        @request.env["SERVER_PROTOCOL"] = "http"
        get :expirings, :format => 'pdf'
      end

      should_respond_with(:success)
      should_render_template("expirings")
      should "send a file" do
        send_file_to_disk(@response.body, "check_list_expiration.pdf")
      end
    end

    context "requesting an item on a non existing check_list" do
      setup do
        get :edit, :check_list_id => rand(10), :id => rand(10)
      end

      should_respond_with(:redirect)
      should_redirect_to(":index") { check_lists_path }

      should_set_the_flash(:error)
    end

    context "requesting a non existing item on an existing check_list" do
      setup do
        get :edit, :check_list_id => @check_list.id, :id => rand(10)
      end

      should_respond_with(:redirect)
      should_redirect_to(":index") { check_list_path(@check_list) }
      
      should_set_the_flash(:error)
    end

    context "requesting GET :new" do
      setup do
        get :new, :check_list_id => @check_list.id
      end

      should_respond_with(:success)
      should_render_template("new")
      should_render_with_layout("back")
    end

    context "requesting POST with bad data" do
      setup do
        post :create, :check_list_id => @check_list.id, :item => {:title => ''}
      end

      should_respond_with(:success)
      should_render_template("new")
      should_render_with_layout("back")

      should_not_change("number of items") { Item.count }
    end

    context "requesting POST with good data" do
      setup do
        post :create, :check_list_id => @check_list.id, :item => {:title => 'Test', :quantity => '1'}
      end

      should_respond_with(:redirect)
      should_redirect_to("check_list") { check_list_path(assigns(:check_list)) }

      should_assign_to(:check_list)
      should_change("number of items", :by => 1) { Item.count }
      should_set_the_flash(:success)
    end

    context "with an existing item" do
      setup do
        @item = @check_list.items.make
      end

      context "requesting GET :edit" do
        setup do
          get :edit, :check_list_id => @check_list.id, :id => @item.id
        end

        should_respond_with(:success)
        should_render_template("edit")
        should_render_with_layout("back")
      end

      context "requesting PUT with bad data" do
        setup do
          put :update, :check_list_id => @check_list.id, :id => @item.id, :item => {:title => '', :quantity => '1'}
        end

        should_respond_with(:success)
        should_render_template("edit")
        should_render_with_layout("back")
      end

      context "requesting PUT with good data" do
        setup do
          put :update, :check_list_id => @check_list.id, :id => @item.id, :item => {:title => 'Test', :quantity => '1'}
        end

        should_respond_with(:redirect)
        should_redirect_to("check_list") { check_list_path(assigns(:check_list)) }

        should_set_the_flash(:success)
      end

      context "requesting PUT with good data and back_path set to expiring" do
        setup do
          session[:back_path] = expirings_items_path
          put :update, :check_list_id => @check_list.id, :id => @item.id, :item => {:title => 'Test', :quantity => '1'}
        end

        should_respond_with(:redirect)
        should_redirect_to("expirings") { expirings_items_path }

        should_set_the_flash(:success)
      end

      context "requesting DELETE :destroy" do
        setup do
          delete :destroy, :check_list_id => @check_list.id, :id => @item.id
        end

        should_redirect_to("check_list") { check_list_path(assigns(:check_list)) }

        should_change("number of items", :by => -1) { Item.count }
        should_set_the_flash(:success)
      end

      context "requesting DELETE :destroy and back_path set to expiring" do
        setup do
          session[:back_path] = expirings_items_path
          delete :destroy, :check_list_id => @check_list.id, :id => @item.id
        end

        should_respond_with(:redirect)
        should_redirect_to("expirings") { expirings_items_path }
        
        should_set_the_flash(:success)
      end
    end
  end
end