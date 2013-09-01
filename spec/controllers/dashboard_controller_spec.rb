# -*- encoding : utf-8 -*-
require 'spec_helper'

describe DashboardController do

  setup(:activate_authlogic)

  context "an user logged in" do

    before(:each) do
      login
    end

    describe "GET :index" do

      before(:each) do
        get :index
      end

      it { should respond_with(:success) }
      it { should render_template("index") }
      it { should render_with_layout("back") }

      it { should assign_to(:messages) }
      it { should assign_to(:interventions) }
      it { should assign_to(:convocations) }
      it { should assign_to(:items) }
    end
  end
end
