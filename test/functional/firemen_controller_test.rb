# -*- encoding : utf-8 -*-
require 'test_helper'

class FiremenControllerTest < ActionController::TestCase

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

      should assign_to(:firemen)
    end
    
    context "requesting GET :resigned" do
      setup do
        get :index
      end

      should respond_with(:success)
      should render_template("index")
      should render_with_layout("back")

      should assign_to(:firemen)
    end    

    context "requesting GET :facebook" do
      setup do
        get :facebook
      end

      should respond_with(:success)
      should render_template("facebook")
      should render_with_layout("back")

      should assign_to(:firemen)
    end

    context "requesting GET :show for a non existing fireman" do
      setup do
        get :show, :id => 2458437589
      end

      should respond_with(:redirect)
      should redirect_to(":index") { firemen_path }

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
        post :create, :fireman => {:firstname => '', :lastname => ''}
      end

      should respond_with(:success)
      should render_template("new")
      should render_with_layout("back")
    end

    context "requesting POST :create with good data" do
      setup do
        post :create, :fireman => plan(Fireman.make(:status => Fireman::STATUS['JSP']))
      end

      should respond_with(:redirect)
      should redirect_to("fireman") { fireman_path(assigns(:fireman)) }

      should assign_to(:fireman)
      should set_the_flash.level(:success)
    end
    
    context "with an existing fireman" do
      setup do
        @fireman = make_fireman_with_grades(:station => @station)
      end

      context "requesting GET :show on existing fireman" do
        setup do
          get :show, :id => @fireman.id
        end

        should respond_with(:success)
        should render_template("show")
        should render_with_layout("back")
      end

      context "requesting GET :edit" do
        setup do
          get :edit, :id => @fireman.id
        end

        should respond_with(:success)
        should render_template("edit")
        should render_with_layout("back")
      end

      context "requesting PUT :update with bad data" do
        setup do
          put :update, :id => @fireman.id, :fireman => {:firstname => '', :lastname => ''}
        end

        should respond_with(:success)
        should render_template("edit")
        should render_with_layout("back")
      end

      context "requesting PUT :update with good data" do
        setup do
          put :update, :id => @fireman.id, :fireman => {:firstname => 'My firstname', :lastname => 'My lastname' }
        end

        should respond_with(:redirect)
        should redirect_to("fireman") { fireman_path(assigns(:fireman)) }

        should set_the_flash.level(:success)
      end

      context "requesting PUT :update with warnings" do
        setup do
          stub.instance_of(Fireman).warnings { 'Warnings' }
          put :update, :id => @fireman.id
        end

        should set_the_flash.level(:warning)
      end

      context "requesting DELETE :destroy without associations" do
        setup do
          delete :destroy, :id => @fireman.id
        end

        should redirect_to("firemen list") { firemen_path }

        should set_the_flash.level(:success)
      end

      context "requesting DELETE :destroy with associations" do
        setup do
          stub.instance_of(Fireman).destroy { false }
          stub.instance_of(Fireman).errors.stub!.full_messages { ["erreur"] }
          delete :destroy, :id => @fireman.id
        end

        should redirect_to("fireman") { fireman_path(assigns(:fireman)) }

        should set_the_flash.level(:error)
      end
    end
  end
end
