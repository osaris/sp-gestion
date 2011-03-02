# -*- encoding : utf-8 -*-
require 'test_helper'

class InterventionsControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "an user logged in" do
    setup do
      login
      @fireman = make_fireman_with_grades(:station => @station)
    end

    context "requesting GET :index" do
      setup do
        get :index
      end

      should respond_with(:success)
      should render_template("index")
      should render_with_layout("back")

      should assign_to(:interventions)
    end

    context "requesting GET :stats with interventions" do
      setup do
        instance_of(Station).interventions.stub!.latest.stub!.first { Intervention.make }
        stub(Intervention).min_max_year { [Date.today.year, Date.today.year] }
        get :stats
      end

      should respond_with(:success)
      should render_template("stats")
      should render_with_layout("back")

      should assign_to(:by_type)
      should assign_to(:by_month)
    end

    context "requesting GET :stats without intervention" do
      setup do
        instance_of(Station).interventions.stub!.latest.stub!.first { nil }
        get :stats
      end

      should respond_with(:redirect)
      should redirect_to(":index") { interventions_path }

      should set_the_flash.level(:warning)
    end

    context "requesting GET :show for a non existing intervention" do
      setup do
        get :show, :id => 2458437589
      end

      should respond_with(:redirect)
      should redirect_to(":index") { interventions_path }

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
        post :create, :intervention => {:place => '', :city => '', :kind => '', :start_date => '', :end_date => '', :fireman_ids => []}
      end

      should respond_with(:success)
      should render_template("new")
      should render_with_layout("back")
    end

    context "requesting POST :create with good data" do
      setup do
        post :create, :intervention => {:place => 'Test', :city => 'MyCity', :kind => '1',
                                        :start_date => I18n.localize(3.hours.ago),
                                        :end_date => I18n.localize(2.hours.ago),
                                        :fireman_ids => [@fireman.id.to_s]}
      end

      should respond_with(:redirect)
      should redirect_to("intervention") { intervention_path(assigns(:intervention)) }

      should assign_to(:intervention)
      should set_the_flash.level(:success)
    end

    context "with an existing intervention not editable" do
      setup do
        @intervention = make_intervention_with_firemen(:station => @station)
        instance_of(Intervention).editable? { false }
      end

      context "requesting GET :edit" do
        setup do
          get :edit, :id => @intervention.id
        end

        should respond_with(:redirect)
        should redirect_to("intervention") { intervention_path(assigns(:intervention)) }

        should set_the_flash.level(:error)
      end

      context "requesting PUT :update with good data" do
        setup do
          put :update, :id => @intervention.id, :intervention => {:place => 'Test', :city => 'MyCity', :kind => '1',
                                                                  :start_date => I18n.localize(3.hours.ago),
                                                                  :end_date => I18n.localize(2.hours.ago),
                                                                  :fireman_ids => [@fireman.id.to_s]}
        end

        should respond_with(:redirect)
        should redirect_to("intervention") { intervention_path(assigns(:intervention)) }

        should set_the_flash.level(:error)
      end
    end

    context "with an existing intervention editable" do
      setup do
        @intervention = make_intervention_with_firemen(:station => @station)
        instance_of(Intervention).editable? { true }
      end

      context "requesting GET :show" do
        setup do
          get :show, :id => @intervention.id
        end

        should respond_with(:success)
        should render_template("show")
        should render_with_layout("back")
      end

      context "requesting GET :edit" do
        setup do
          get :edit, :id => @intervention.id
        end

        should respond_with(:success)
        should render_template("edit")
        should render_with_layout("back")
      end

      context "requesting PUT :update with bad data" do
        setup do
          put :update, :id => @intervention.id, :intervention => {:place => '', :city => '', :kind => '', :start_date => '', :end_date => '', :fireman_ids => []}
        end

        should respond_with(:success)
        should render_template("edit")
        should render_with_layout("back")
      end

      context "requesting PUT :update with good data" do
        setup do
          put :update, :id => @intervention.id, :intervention => {:place => 'Test', :city => 'MyCity', :kind => '1',
                                                                  :start_date => I18n.localize(3.hours.ago),
                                                                  :end_date => I18n.localize(2.hours.ago),
                                                                  :fireman_ids => [@fireman.id.to_s]}
        end

        should respond_with(:redirect)
        should redirect_to("intervention") { intervention_path(assigns(:intervention)) }

        should set_the_flash.level(:success)
      end

      context "requesting DELETE :destroy" do
        setup do
          delete :destroy, :id => @intervention.id
        end

        should redirect_to("interventions list") { interventions_path }

        should set_the_flash.level(:success)
      end
    end
  end
end
