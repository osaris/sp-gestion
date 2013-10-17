require 'spec_helper'

describe AccountsController do

  setup(:activate_authlogic)

  let(:user) { User.make!(:confirmed) }

  let(:logo) { fixture_file_upload('/files/uploads/logo/logo.png', 'image/png') }

  let(:logo_txt) { fixture_file_upload('/files/uploads/logo/logo.txt', 'text/plain') }

  describe "GET :edit" do

    context "an user logged in but not owner of station" do

      before do
        login

        get :edit
      end

      it { should redirect_to(root_back_url) }
    end

    context "an user logged in and owner of station in demo mode" do

      before do
        login(Station.make!(:demo => true))

        get :edit
      end

      it { should redirect_to(root_back_url) }

      it { should set_the_flash[:error] }
    end

    context "an user logged in and station owner" do

      before do
        login(Station.make!(:owner_id => user.id), user)

        get :edit
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("back") }

      it { expect(assigns(:users)).to_not be_nil }
    end
  end

  describe "PATCH :update_settings with remove logo" do

    context "a station with a logo" do

      before do
        login(Station.make!(:logo, :owner_id => user.id), user)

        patch :update_settings, :station => { :remove_logo => '1' }
      end

      it "delete logo station" do
        assigns(:station).reload.logo?.should be_false
      end

      it { should set_the_flash[:success] }
    end
  end

  describe "PATCH :update_settings with new logo" do

    before do
      login(Station.make!(:owner_id => user.id), user)

      patch :update_settings, :station => { :logo => logo }
    end

    it "add logo to station" do
      assigns(:station).reload.logo?.should be_true
    end

    it { should set_the_flash[:success] }
  end

  describe "PATCH :update_settings with bad logo" do

    before do
      login(Station.make!(:owner_id => user.id), user)

      patch :update_settings, :station => { :logo => logo_txt }
    end

    it "doesn't add logo to station" do
      assigns(:station).reload.logo?.should be_false
    end

    it { should set_the_flash[:error] }
  end

  describe "PATCH :update_owner with good data" do

    before do
      login(Station.make!(:owner_id => user.id), user)
      allow_any_instance_of(Station).to receive(:update_owner).and_return(true)

      patch :update_owner, :station => { :owner_id => '' }
    end

    it { should redirect_to(root_back_url) }

    it { should set_the_flash[:success] }
  end

  describe "PATCH :update_owner with bad data" do

    before do
      login(Station.make!(:owner_id => user.id), user)
      allow_any_instance_of(Station).to receive(:update_owner).and_return(false)

      patch :update_owner, :station => { :owner_id => '' }
    end

    it { should redirect_to(root_back_url) }

    it { should set_the_flash[:error] }
  end

  describe "DELETE :destroy" do

    before do
      login(Station.make!(:owner_id => user.id), user)
      @request.host = "#{@station.url}.test.local"

      delete :destroy
    end

    it { should redirect_to("http://www.test.local/bye") }
  end
end
