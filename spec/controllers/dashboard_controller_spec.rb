# -*- encoding : utf-8 -*-
require 'rails_helper'

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

      it { expect(assigns(:messages)).to_not be_nil}
      it { expect(assigns(:interventions)).to_not be_nil}
      it { expect(assigns(:convocations)).to_not be_nil}
      it { expect(assigns(:items)).to_not be_nil}
    end
  end
end
