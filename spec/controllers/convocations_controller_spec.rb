require 'rails_helper'

describe ConvocationsController do

  setup(:activate_authlogic)

  context "an user logged in" do

    before(:each) do
      login
    end

    let(:uniform) { create(:uniform) }

    let(:fireman) { create(:fireman, :station => @station) }

    let(:convocation) { create(:convocation, :station => @station) }

    describe "GET :index" do

      before(:each) do
        get :index
      end

      it { should respond_with(:success) }
      it { should render_template("index") }
      it { should render_with_layout("back") }

      it { expect(assigns(:convocations)).to_not be_nil}
    end

    describe "GET :show for a non existing convocation" do

      before(:each) do
        get :show, :params => { :id => 2458437589 }
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(convocations_path) }

      it { should set_flash[:error] }
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
        post :create, :params => { :convocation => {:title => '', :date => '', :place => '',
                                       :uniform_id => '', :fireman_ids => []}  }
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("back") }
    end

    describe "POST :create with good data" do
      before(:each) do
        post :create, :params => { :convocation => {:title => "Test", :date => I18n.localize(2.weeks.from_now), :place => "Test lieu",
                                       :fireman_ids => [fireman.id.to_s], :uniform_id => uniform.id.to_s} }
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(convocation_path(assigns(:convocation))) }

      it { should set_flash[:success] }
    end

    context "with an existing convocation not editable" do

      before(:each) do
        # stub the validator because convocation can't be saved if editable?
        # returns false
        allow_any_instance_of(ConvocationValidator).to receive(:validate).and_return(true)
        allow_any_instance_of(Convocation).to receive(:editable?).and_return(false)
      end

      describe "GET :edit" do

        before(:each) do
          get :edit, :params => { :id => convocation.id }
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(convocation_path(assigns(:convocation))) }

        it { should set_flash[:error] }
      end

      describe "PATCH :update with good data" do

        before(:each) do
          patch :update,:params => { :id => convocation.id, :convocation => {:title => "Test", :date => I18n.localize(2.weeks.from_now), :place => "Test lieu",
                                                                :fireman_ids => [fireman.id.to_s], :uniform_id => uniform.id.to_s} }
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(convocation_path(assigns(:convocation))) }

        it { should set_flash[:error] }
      end

      describe "POST :email with  with email quota not exceeded" do

        before(:each) do
          allow_any_instance_of(Station).to receive(:can_send_email?).and_return(true)

          post :email, :params => { :id => convocation.id }
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(convocation_path(assigns(:convocation))) }

        it { should set_flash[:error] }
      end
    end

    context "with an existing convocation" do

      describe "GET :show on existing convocation" do

        before(:each) do
          get :show, :params => { :id => convocation.id }
        end

        it { should respond_with(:success) }
        it { should render_template("show") }
        it { should render_with_layout("back") }

        it { expect(assigns(:convocation)).to_not be_nil}
      end

      describe "GET :show on existing convocation with PDF format" do

        before(:each) do
          @request.env["SERVER_PROTOCOL"] = "http"

          get :show, :params => { :id => convocation.id, :format => 'pdf' }
        end

        it { should respond_with(:success) }
        it { should render_template("show") }
        it "sends a file" do
          send_file_to_disk(@response.body, "convocation.pdf")
        end
      end

      describe "GET :edit" do

        before(:each) do
          get :edit, :params => { :id => convocation.id }
        end

        it { should respond_with(:success) }
        it { should render_template("edit") }
        it { should render_with_layout("back") }
      end

      describe "PATCH :update with bad data" do

        before(:each) do
          patch :update, :params => { :id => convocation.id, :convocation => {:title => "", :date => I18n.localize(2.weeks.from_now), :place => "",
                                                                :fireman_ids => [fireman.id.to_s], :uniform_id => uniform.id.to_s} }
        end

        it { should respond_with(:success) }
        it { should render_template("edit") }
        it { should render_with_layout("back") }
      end

      describe "PATCH :update with good data" do

        before(:each) do
          patch :update, :params => { :id => convocation.id, :convocation => {:title => "Test", :date => I18n.localize(2.weeks.from_now), :place => "Test lieu",
                                                                :fireman_ids => [fireman.id.to_s], :uniform_id => uniform.id.to_s} }
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(convocation_path(assigns(:convocation))) }

        it { should set_flash[:success] }
      end

      describe "DELETE :destroy" do

        before(:each) do
          delete :destroy, :params => { :id => convocation.id }
        end

        it { should redirect_to(convocations_path) }

        it { should set_flash[:success] }
      end

      describe "POST :email with email quota not exceeded" do

        before(:each) do
          allow_any_instance_of(Station).to receive(:can_send_email?).and_return(true)

          post :email, :params => {:id => convocation.id}
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(convocation_path(assigns(:convocation))) }

        it { should set_flash[:success] }
      end

      describe "POST :email with email quota exceeded" do

        before(:each) do
          # because rspec fails on render_to_string in controller
          allow(controller).to receive(:render_to_string).with(any_args).and_return('erreur')
          allow_any_instance_of(Station).to receive(:can_send_email?).and_return(false)

          post :email, :params => { :id => convocation.id }
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(convocation_path(assigns(:convocation))) }

        it { should set_flash[:error] }
      end
    end
  end
end
