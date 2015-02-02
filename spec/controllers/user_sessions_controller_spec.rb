require 'rails_helper'

describe UserSessionsController do

  setup(:activate_authlogic)

  context "a station subdomain" do

    before(:each) do
      @station = create(:station, :url => 'cis-test')
      @request.host = 'cis-test.sp-gestion.fr'
    end

    describe "GET :new" do

      before(:each) do
        get :new
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("login") }
    end

    context "with a user on another account" do

      before(:each) do
        @user = create(:user_confirmed, :station => create(:station))
      end

      describe "POST :create with good data" do

        before(:each) do
          post :create, :user_session => {:email => @user.email, :password => 'test1234'}
        end

        it { should respond_with(:success) }
        it { should render_template("new") }
        it { should render_with_layout("login") }

        it { should_not be_logged_in }
        it { should set_flash[:error].now }
      end
    end

    context "with a user on this account" do

      before(:each) do
        @user = create(:user_confirmed, :station => @station)
      end

      describe "POST :create with bad data" do

        before(:each) do
          post :create, :user => {:login => 'test', :password => 'pass'}
        end

        it { should respond_with(:success) }
        it { should render_template("new") }
        it { should render_with_layout("login") }

        it { should_not be_logged_in }
        it { should set_flash[:error].now }
      end

      describe "POST :create with good data" do

        before(:each) do
          post :create, :user_session => {:email => @user.email, :password => 'test1234'}
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(root_back_path) }

        it { should be_logged_in }
      end

      describe "DELETE :destroy not logged in" do

        before(:each) do
          delete :destroy
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(login_path) }

        it { should_not be_logged_in }
      end

      describe "DELETE :destroy logged in" do

        before(:each) do
          UserSession.create(@user)
          delete :destroy
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(login_path) }

        it { should_not be_logged_in }
        it { should set_flash[:success] }
      end
    end
  end
end
