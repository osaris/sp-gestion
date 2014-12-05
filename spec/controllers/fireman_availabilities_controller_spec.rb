require 'rails_helper'

describe FiremanAvailabilitiesController do

  setup(:activate_authlogic)

  context "an user logged in" do

    before(:each) do
      login
    end

    let(:fireman) { create(:fireman, :station => @station) }

    let(:fireman_availability) { create(:fireman_availability,
                                        :fireman => fireman,
                                        :station => @station) }

    let(:fireman_availability_passed) { create(:fireman_availability_passed,
                                               :fireman => fireman,
                                               :station => @station) }

    describe "GET :index on non existing fireman" do

      before(:each) do
        get :index, :fireman_id => -1, :format => :html
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(firemen_path) }

      it { should set_the_flash.level(:error) }
    end

    describe "GET :index on not active fireman" do

      before(:each) do
        fireman
        allow_any_instance_of(Fireman).to receive(:status) { Fireman::STATUS['JSP'] }

        get :index, :fireman_id => fireman.id, :format => :html
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(fireman_path(assigns(:fireman))) }

      it { should set_the_flash.level(:error) }

    end

    describe "GET :index with JSON format" do

      before(:each) do
        get :index, :fireman_id => fireman.id, :start => '2014-11-24',
                    :end => '2014-11-30', :format => :json
      end

      it { should respond_with(:success) }
      it { should render_template("index") }
      it { should_not render_with_layout }
    end

    describe "GET :index with HTML format" do

      before(:each) do
        get :index, :fireman_id => fireman.id
      end

      it { should respond_with(:success) }
      it { should render_template("index") }
      it { should render_with_layout("back") }
    end

    describe "POST :create" do

      before(:each) do
        post :create, :fireman_id => fireman.id,
                      :fireman_availability => { :fireman_id => fireman.id,
                                                 :availability => (Time.now + 1.day).to_s },
                      :format => :json
      end

      it { should respond_with(:success) }
      it { expect(assigns(:fireman_availability)).to_not be_nil }
      it { should_not render_with_layout }
    end

    describe "POST :create with error" do

      before(:each) do
        post :create, :fireman_id => fireman.id,
                      :fireman_availability => { :fireman_id => fireman.id,
                                                 :availability => '2014-11-30T16:00:00+01:00' },
                      :format => :json
      end

      it { should respond_with(:unprocessable_entity) }
      it { should_not render_with_layout }
    end

    describe "POST :create_all" do

      before(:each) do
        post :create_all, :fireman_id => fireman.id,
                          :fireman_availability => { :fireman_id => fireman.id,
                                                     :availability => '2014-12-18T00:00:00+01:00'}
      end

      it { should respond_with(:success) }
      it { should_not render_with_layout }
    end

    describe "DELETE :destroy" do

      before(:each) do
        delete :destroy, :fireman_id => fireman.id,
                         :id => fireman_availability.id,
                         :format => :json
      end

      it { should respond_with(:success) }
      it { should_not render_with_layout }
    end

    describe "DELETE :destroy with error" do

      before(:each) do
        delete :destroy, :fireman_id => fireman.id,
                         :id => fireman_availability_passed.id,
                         :format => :json
      end

      it { should respond_with(:unprocessable_entity) }
      it { should_not render_with_layout }
    end

    describe "DELETE :destroy not found" do

      before(:each) do
        delete :destroy, :fireman_id => fireman.id, :id => -1, :format => :json
      end

      it { should respond_with(:not_found) }
      it { should_not render_with_layout }
    end

    describe "DELETE :destroy_all" do

      before(:each) do
        delete :destroy_all, :fireman_id => fireman.id,
                             :fireman_availability => { :fireman_id => fireman.id,
                                                        :availability => '2014-12-18T00:00:00+01:00'}
      end

      it { should respond_with(:success) }
      it { should_not render_with_layout }
    end
  end
end
