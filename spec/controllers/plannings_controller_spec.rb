require 'rails_helper'

describe PlanningsController do

  setup(:activate_authlogic)

  context "an user logged in" do

    before(:each) do
      login
    end

    describe "GET :show by_grade with HTML format" do

      before(:each) do
        get :show, :id => 'by_grade', :format => :html
      end

      it { should respond_with(:success) }
      it { should render_template("show") }
      it { should render_with_layout("back") }

      it { expect(assigns(:grades)).to_not be_nil }
    end

    describe "GET :show by_training with HTML format" do

      before(:each) do
        get :show, :id => 'by_training', :format => :html
      end

      it { should respond_with(:success) }
      it { should render_template("show") }
      it { should render_with_layout("back") }

      it { expect(assigns(:trainings)).to_not be_nil }
    end

    describe "GET :show general with JSON format" do

      before(:each) do
        get :show, :id => 'general', :start => Time.now.to_s, :format => :json
      end

      it { should respond_with(:success) }
      it { should render_template("show") }
      it { should_not render_with_layout }

      it { expect(assigns(:availabilities)).to_not be_nil }
      it { expect(assigns(:number_of_firemen)).to_not be_nil }
    end

    describe "GET :show by_grade with JSON format" do

      before(:each) do
        get :show, :id => 'by_grade', :start => Time.now.to_s, :format => :json
      end

      it { should respond_with(:success) }
      it { should render_template("show") }
      it { should_not render_with_layout }

      it { expect(assigns(:availabilities)).to_not be_nil }
      it { expect(assigns(:number_of_firemen)).to_not be_nil }
    end

    describe "GET :show by_training with JSON format" do

      before(:each) do
        get :show, :id => 'by_training', :start => Time.now.to_s, :format => :json
      end

      it { should respond_with(:success) }
      it { should render_template("show") }
      it { should_not render_with_layout }

      it { expect(assigns(:availabilities)).to_not be_nil }
      it { expect(assigns(:number_of_firemen)).to_not be_nil }
    end

    describe "GET :firemen" do

      before(:each) do
        get :firemen, :type => 'general'
      end

      it { should respond_with(:success) }
      it { should render_template("_firemen") }
      it { should_not render_with_layout }

      it { expect(assigns(:firemen)).to_not be_nil }
    end

    describe "GET :stats" do

      before(:each) do
        get :stats, :type => 'general'
      end

      it { should respond_with(:success) }
      it { should render_template("_stats") }
      it { should_not render_with_layout }
    end
  end
end
