require 'rails_helper'

describe FiremenController do

  setup(:activate_authlogic)

  context "an user logged in" do

    before(:each) do
      login
    end

    let(:fireman) { create(:fireman, :station => @station) }

    describe "GET :index" do

      before(:each) do
        get :index
      end

      it { should respond_with(:success) }
      it { should render_template("index") }
      it { should render_with_layout("back") }

      it { expect(assigns(:firemen)).to_not be_nil}
    end

    describe "GET :resigned" do

      before(:each) do
        get :resigned
      end

      it { should respond_with(:success) }
      it { should render_template("index") }
      it { should render_with_layout("back") }

      it { expect(assigns(:firemen)).to_not be_nil}
    end

    describe "GET :facebook" do

      before(:each) do
        get :facebook
      end

      it { should respond_with(:success) }
      it { should render_template("facebook") }
      it { should render_with_layout("back") }

      it { expect(assigns(:firemen)).to_not be_nil}
    end

    describe "GET :show for a non existing fireman" do

      before(:each) do
        get :show, :id => 2458437589
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(firemen_path) }

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
        post :create, :fireman => {:firstname => '', :lastname => ''}
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("back") }
    end

    describe "POST :create with good data" do

      before(:each) do
        post :create, :fireman => attributes_for(:fireman, :status => Fireman::STATUS['JSP'])
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(fireman_path(assigns(:fireman))) }

      it { expect(assigns(:fireman)).to_not be_nil}
      it { should set_the_flash.level(:success) }
    end

    describe "GET :stats_change_year" do

      before(:each) do
        get :stats_change_year, :id => fireman.id, :type => 'convocations', :new_year => (Date.today.year+1).to_s
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(firemen_stats_path(assigns(:fireman), (Date.today.year+1), 'convocations')) }
    end

    describe "GET :stats with no data" do

      before(:each) do
        allow_any_instance_of(Fireman).to receive(:years_stats).and_return([])

        get :stats, :id => fireman.id, :year => (Date.today.year).to_s, :type => 'convocations'
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(fireman_path(assigns(:fireman))) }

      it { should set_the_flash.level(:error) }
    end

    describe "GET :stats with bad year" do

      before(:each) do
        allow_any_instance_of(Fireman).to receive(:years_stats).and_return([Date.today.year+1, Date.today.year])

        get :stats, :id => fireman.id, :year => (Date.today.year-1).to_s, :type => 'convocations'
      end

      it { should redirect_to(firemen_stats_path(assigns(:fireman), (Date.today.year+1), 'convocations')) }
    end

    describe "GET :stats with bad type" do

      before(:each) do
        allow_any_instance_of(Fireman).to receive(:years_stats).and_return([Date.today.year+1, Date.today.year])

        get :stats, :id => fireman.id, :year => Date.today.year.to_s, :type => 'badtype'
      end

      it { should redirect_to(firemen_stats_path(assigns(:fireman), Date.today.year, 'convocations')) }
    end

    describe "GET :stats" do

      before(:each) do
        allow_any_instance_of(Fireman).to receive(:years_stats).and_return([Date.today.year+1, Date.today.year])

        get :stats, :id => fireman.id, :year => Date.today.year.to_s, :type => 'convocations'
      end

      it { should respond_with(:success) }
      it { should render_template("stats") }
      it { should render_with_layout("back") }

      it { expect(assigns(:data)).to_not be_nil}
    end

    describe "GET :show on existing fireman" do

      before(:each) do
        get :show, :id => fireman.id
      end

      it { should respond_with(:success) }
      it { should render_template("show") }
      it { should render_with_layout("back") }
    end

    describe "GET :trainings" do

      before(:each) do
        get :trainings, :id => fireman.id
      end

      it { should respond_with(:success) }
      it { should render_template("trainings") }
      it { should render_with_layout("back") }
    end

    describe "GET :edit" do

      before(:each) do
        get :edit, :id => fireman.id
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("back") }
    end

    describe "PATCH :update with bad data" do

      before(:each) do
        patch :update, :id => fireman.id, :fireman => {:firstname => '', :lastname => ''}
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("back") }
    end

    describe "PATCH :update with good data" do

      before(:each) do
        patch :update, :id => fireman.id, :fireman => {:firstname => 'My firstname', :lastname => 'My lastname' }
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(fireman_path(assigns(:fireman))) }

      it { should set_the_flash.level(:success) }
    end

    describe "PATCH :update with warnings" do

      before(:each) do
        allow_any_instance_of(Fireman).to receive(:warnings).and_return('Warning')

        patch :update, :id => fireman.id, :fireman => {:firstname => 'My firstname', :lastname => 'My lastname' }
      end

      it { should set_the_flash.level(:warning) }
    end

    describe "DELETE :destroy without associations" do

      before(:each) do
        delete :destroy, :id => fireman.id
      end

      it { should redirect_to(firemen_path) }

      it { should set_the_flash.level(:success) }
    end

    describe "DELETE :destroy with associations" do

      before(:each) do
        allow_any_instance_of(Fireman).to receive(:interventions).and_return(double(:empty? => false))

        delete :destroy, :id => fireman.id
      end

      it { should redirect_to(fireman_path(assigns(:fireman))) }
      it { should set_the_flash.level(:error) }
    end
  end
end
