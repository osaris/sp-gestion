# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ConvocationsController do

  setup(:activate_authlogic)

  context "an user logged in" do

    before(:each) do
      login
    end

    let(:uniform) { Uniform.make! }

    let(:fireman) { make_fireman_with_grades(:station => @station) }

    let(:convocation) { make_convocation_with_firemen(:station => @station) }

    describe "GET :index" do

      before(:each) do
        get :index
      end

      it { should respond_with(:success) }
      it { should render_template("index") }
      it { should render_with_layout("back") }

      it { should assign_to(:convocations) }
    end

    describe "GET :show for a non existing convocation" do

      before(:each) do
        get :show, :id => 2458437589
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(convocations_path) }

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
        post :create, :convocation => {:title => '', :date => '', :place => '',
                                       :uniform_id => '', :fireman_ids => []}
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("back") }
    end

    describe "POST :create with good data" do
      before(:each) do
        post :create, :convocation => {:title => "Test", :date => I18n.localize(2.weeks.from_now), :place => "Test lieu",
                                       :fireman_ids => [fireman.id.to_s], :uniform_id => uniform.id.to_s}
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(convocation_path(assigns(:convocation))) }

      it { should set_the_flash.level(:success) }
    end

    context "with an existing convocation not editable" do

      before(:each) do
        # stub the validator because convocation can't be saved if editable?
        # returns false
        ConvocationValidator.any_instance.stub(:validate).and_return(true)
        Convocation.any_instance.stub(:editable?).and_return(false)
      end

      describe "GET :edit" do

        before(:each) do
          get :edit, :id => convocation.id
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(convocation_path(assigns(:convocation))) }

        it { should set_the_flash.level(:error) }
      end

      describe "PUT :update with good data" do

        before(:each) do
          put :update, :id => convocation.id, :convocation => {:title => "Test", :date => I18n.localize(2.weeks.from_now), :place => "Test lieu",
                                                                :fireman_ids => [fireman.id.to_s], :uniform_id => uniform.id.to_s}
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(convocation_path(assigns(:convocation))) }

        it { should set_the_flash.level(:error) }
      end

      describe "POST :email with  with email quota not exceeded" do

        before(:each) do
          Station.any_instance.stub(:can_send_email?).and_return(true)

          post :email, :id => convocation.id
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(convocation_path(assigns(:convocation))) }

        it { should set_the_flash.level(:error) }
      end
    end

    context "with an existing convocation" do

      describe "GET :show on existing convocation" do

        before(:each) do
          get :show, :id => convocation.id
        end

        it { should respond_with(:success) }
        it { should render_template("show") }
        it { should render_with_layout("back") }

        it { should assign_to(:convocation) }
      end

      describe "GET :show on existing convocation with PDF format" do

        before(:each) do
          @request.env["SERVER_PROTOCOL"] = "http"

          get :show, :id => convocation.id, :format => 'pdf'
        end

        it { should respond_with(:success) }
        it { should render_template("show") }
        it "sends a file" do
          send_file_to_disk(@response.body, "convocation.pdf")
        end
      end

      describe "GET :edit" do

        before(:each) do
          get :edit, :id => convocation.id
        end

        it { should respond_with(:success) }
        it { should render_template("edit") }
        it { should render_with_layout("back") }
      end

      describe "PUT :update with bad data" do

        before(:each) do
          put :update, :id => convocation.id, :convocation => {:title => "", :date => I18n.localize(2.weeks.from_now), :place => "",
                                                                :fireman_ids => [fireman.id.to_s], :uniform_id => uniform.id.to_s}
        end

        it { should respond_with(:success) }
        it { should render_template("edit") }
        it { should render_with_layout("back") }
      end

      describe "PUT :update with good data" do

        before(:each) do
          put :update, :id => convocation.id, :convocation => {:title => "Test", :date => I18n.localize(2.weeks.from_now), :place => "Test lieu",
                                                                :fireman_ids => [fireman.id.to_s], :uniform_id => uniform.id.to_s}
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(convocation_path(assigns(:convocation))) }

        it { should set_the_flash.level(:success) }
      end

      describe "DELETE :destroy" do

        before(:each) do
          delete :destroy, :id => convocation.id
        end

        it { should redirect_to(convocations_path) }

        it { should set_the_flash.level(:success) }
      end

      describe "POST :email with email quota not exceeded" do

        before(:each) do
          Station.any_instance.stub(:can_send_email?).and_return(true)

          post :email, :id => convocation.id
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(convocation_path(assigns(:convocation))) }

        it { should set_the_flash.level(:success) }
      end

      describe "POST :email with email quota exceeded" do

        before(:each) do
          # because rspec fails on render_to_string in controller
          controller.stub(:render_to_string).with(any_args).and_return('erreur')
          Station.any_instance.stub(:can_send_email?).and_return(false)

          post :email, :id => convocation.id
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(convocation_path(assigns(:convocation))) }

        it { should set_the_flash.level(:error) }
      end
    end
  end
end
