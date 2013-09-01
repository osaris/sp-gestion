# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UniformsController do

  setup(:activate_authlogic)

  context "an user logged in" do

    before(:each) do
      login
    end

    let(:uniform) { @station.uniforms.make! }

    describe "GET :index" do

      before(:each) do
        get :index
      end

      it { should respond_with(:success) }
      it { should render_template("index")  }
      it { should render_with_layout("back") }

      it { should assign_to(:uniforms) }
    end

    describe "GET :show for a non existing uniform" do

      before(:each) do
        get :show, :id => -1
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(uniforms_path) }

      it { should set_the_flash.level(:error) }
    end

    describe "GET :new" do

      before(:each) do
        get :new
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("back") }
    end

    describe "POST :create with bad data" do

      before(:each) do
        post :create, :uniform => {:title => '', :code => '2b', :description => 'test'}
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("back") }
    end

    describe "POST :create with good data" do

      before(:each) do
        post :create, :uniform => plan(Uniform.make)
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(uniform_path(assigns(:uniform))) }

      it { should assign_to(:uniform) }
      it { should set_the_flash.level(:success) }
    end

    describe "POST :reset" do

      before(:each) do
        post :reset
      end

      it { should respond_with(:redirect) }

      it { should set_the_flash.level(:success) }
    end

    describe "GET :show on existing uniform" do

      before(:each) do
        get :show, :id => uniform.id
      end

      it { should respond_with(:success) }
      it { should render_template("show") }
      it { should render_with_layout("back") }
    end

    describe "GET :edit" do

      before(:each) do
        get :edit, :id => uniform.id
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("back") }
    end

    describe "PUT :update with bad data" do

      before(:each) do
        put :update, :id => uniform.id, :uniform => {:title => '', :code => '2b', :description => 'test'}
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("back") }
    end

    describe "PUT :update with good data" do

      before(:each) do
        put :update, :id => uniform.id, :uniform => plan(Uniform.make)
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(uniform_path(assigns(:uniform))) }

      it { should set_the_flash.level(:success) }
    end

    describe "DELETE :destroy without association" do

      before(:each) do
        delete :destroy, :id => uniform.id
      end

      it { should redirect_to(uniforms_path) }

      it { should set_the_flash.level(:success) }
    end

    describe "DELETE :destroy with associations" do

      before(:each) do
        Uniform.any_instance.stub(:convocations => { :empty? => false })

        delete :destroy, :id => uniform.id
      end

      it { should redirect_to(uniform_path(assigns(:uniform))) }

      it { should set_the_flash.level(:error) }
    end
  end
end
