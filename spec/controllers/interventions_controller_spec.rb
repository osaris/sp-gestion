# -*- encoding : utf-8 -*-
require 'spec_helper'

describe InterventionsController do

  setup(:activate_authlogic)

  context "an user logged in" do

    before(:each) do
      login
    end

    let(:fireman) { make_fireman_with_grades(:station => @station) }

    describe "GET :index" do

      before(:each) do
        get :index
      end

      it { should respond_with(:success) }
      it { should render_template("index") }
      it { should render_with_layout("back") }

      it { expect(assigns(:interventions)).to_not be_nil}
    end

    describe "GET :stats with interventions" do

      before(:each) do
        i = make_intervention_with_firemen(:station => @station)
        allow_any_instance_of(Station).to receive(:interventions).and_return(double(:latest => {:first => i}))
        allow_any_instance_of(Intervention).to receive(:years_stats).and_return([Date.today.year+1, Date.today.year])
      end

      describe "GET :stats with bad year" do

        before(:each) do
          get :stats, :year => (Date.today.year-1).to_s, :type => 'by_month'
        end

        it { should redirect_to(interventions_stats_path((Date.today.year), 'by_month')) }
      end

      describe "GET :stats with bad type" do

        before(:each) do
          get :stats, :year => Date.today.year.to_s, :type => 'by_badtype'
        end

        it { should redirect_to(interventions_stats_path(Date.today.year, 'by_type')) }
      end

      describe "GET :stats" do

        before(:each) do
          get :stats, :year => Date.today.year.to_s, :type => "by_month"
        end

        it { should respond_with(:success) }
        it { should render_template("stats") }
        it { should render_with_layout("back") }

        it { expect(assigns(:data)).to_not be_nil}
        it { expect(assigns(:sum)).to_not be_nil}
      end
    end

    describe "GET :stats_change_year" do

      before(:each) do
        get :stats_change_year, :type => 'by_month', :new_year => (Date.today.year+1).to_s
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(interventions_stats_path((Date.today.year+1), 'by_month')) }
    end

    describe "GET :stats without intervention" do

      before(:each) do
        allow_any_instance_of(Station).to receive(:interventions).and_return(double(:latest => double(:first => nil)))

        get :stats, :year => Date.today.year.to_s, :type => "by_month"
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(interventions_path) }

      it { should set_the_flash.level(:warning) }
    end

    describe "GET :show for a non existing intervention" do

      before(:each) do
        get :show, :id => 2458437589
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(interventions_path) }

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
        post :create, :intervention => {:place => '', :city => '', :kind => '', :start_date => '', :end_date => '', :fireman_interventions_attributes => {}}
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("back") }
    end

    describe "POST :create with good data" do

      before(:each) do
        post :create, :intervention => {:place => 'Test', :city => 'MyCity', :kind => '1',
                                        :start_date => I18n.localize(3.hours.ago),
                                        :end_date => I18n.localize(2.hours.ago),
                                        :fireman_interventions_attributes => {
                                          '0' => {
                                            :enable => '1',
                                            :fireman_id => fireman.id.to_s,
                                            :intervention_role_id => '',
                                          }}}
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(intervention_path(assigns(:intervention))) }

      it { expect(assigns(:intervention)).to_not be_nil}
      it { should set_the_flash.level(:success) }
    end

    context "with an existing intervention not editable" do

      let(:intervention) { make_intervention_with_firemen(:station => @station) }

      before(:each) do
        allow_any_instance_of(Intervention).to receive(:editable?).and_return(false)
      end

      describe "GET :edit" do

        before(:each) do
          get :edit, :id => intervention.id
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(intervention_path(assigns(:intervention))) }

        it { should set_the_flash.level(:error) }
      end

      describe "PUT :update with good data" do

        before(:each) do
          put :update, :id => intervention.id, :intervention => {:place => 'Test', :city => 'MyCity', :kind => '1',
                                                                  :start_date => I18n.localize(3.hours.ago),
                                                                  :end_date => I18n.localize(2.hours.ago),
                                                                  :fireman_interventions_attributes => {
                                                                    '0' => {
                                                                      :enable => '1',
                                                                      :fireman_id => fireman.id.to_s,
                                                                      :intervention_role_id => '',
                                                                    }}}
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(intervention_path(assigns(:intervention))) }

        it { should set_the_flash.level(:error) }
      end
    end

    context "with an existing intervention editable" do

      let(:intervention) { make_intervention_with_firemen(:station => @station) }

      before(:each) do
        allow_any_instance_of(Intervention).to receive(:editable?).and_return(true)
      end

      describe "GET :show" do

        before(:each) do
          get :show, :id => intervention.id
        end

        it { should respond_with(:success) }
        it { should render_template("show") }
        it { should render_with_layout("back") }
      end

      describe "GET :edit" do

        before(:each) do
          get :edit, :id => intervention.id
        end

        it { should respond_with(:success) }
        it { should render_template("edit") }
        it { should render_with_layout("back") }
      end

      describe "PUT :update with bad data" do

        before(:each) do
          put :update, :id => intervention.id, :intervention => {:place => '', :city => '', :kind => '', :start_date => '', :end_date => '', :fireman_interventions_attributes => {}}
        end

        it { should respond_with(:success) }
        it { should render_template("edit") }
        it { should render_with_layout("back") }
      end

      describe "PUT :update with good data" do

        before(:each) do
          put :update, :id => intervention.id, :intervention => {:place => 'Test', :city => 'MyCity', :kind => '1',
                                                                  :start_date => I18n.localize(3.hours.ago),
                                                                  :end_date => I18n.localize(2.hours.ago),
                                                                  :fireman_interventions_attributes => {
                                                                    '0' => {
                                                                      :enable => '1',
                                                                      :fireman_id => fireman.id.to_s,
                                                                      :intervention_role_id => '',
                                                                    }}}
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(intervention_path(assigns(:intervention))) }

        it { should set_the_flash.level(:success) }
      end

      describe "DELETE :destroy" do

        before(:each) do
          delete :destroy, :id => intervention.id
        end

        it { should redirect_to(interventions_path) }

        it { should set_the_flash.level(:success) }
      end
    end
  end
end
