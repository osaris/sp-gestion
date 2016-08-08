require 'rails_helper'

describe AccountsController do

  setup(:activate_authlogic)

  let(:user) { create(:user_confirmed) }

  let(:logo) { fixture_file_upload('/files/uploads/logo/logo_test.png', 'image/png') }

  let(:logo_txt) { fixture_file_upload('/files/uploads/logo/logo_test.txt', 'text/plain') }

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
        login(create(:station, :demo => true))

        get :edit
      end

      it { should redirect_to(root_back_url) }

      it { should set_flash[:error] }
    end

    context "an user logged in and owner" do

      before do
        login(create(:station, :owner_id => user.id), user)

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
        login(create(:station_logo, :owner_id => user.id), user)

        patch :update_settings, :params => { :station => { :remove_logo => '1' } }
      end

      it "delete logo station" do
        expect(assigns(:station).reload.logo?).to be_falsey
      end

      it { should set_flash[:success] }
    end
  end

  describe "PATCH :update_settings with new logo" do

    before do
      login(create(:station, :owner_id => user.id), user)

      patch :update_settings, :params => { :station => { :logo => logo } }
    end

    it "add logo to station" do
      expect(assigns(:station).reload.logo?).to be_truthy
    end

    it { should set_flash[:success] }
  end

  describe "PATCH :update_settings with bad logo" do

    before do
      login(create(:station, :owner_id => user.id), user)

      patch :update_settings, :params => { :station => { :logo => logo_txt } }
    end

    it "doesn't add logo to station" do
      expect(assigns(:station).reload.logo?).to be_falsey
    end

    it { should set_flash[:error] }
  end

  describe "PATCH :update_owner with good data" do

    before do
      login(create(:station, :owner_id => user.id), user)
      allow_any_instance_of(Station).to receive(:update_owner).and_return(true)

      patch :update_owner, :params => { :station => { :owner_id => '' } }
    end

    it { should redirect_to(root_back_url) }

    it { should set_flash[:success] }
  end

  describe "PATCH :update_owner with bad data" do

    before do
      login(create(:station, :owner_id => user.id), user)
      allow_any_instance_of(Station).to receive(:update_owner).and_return(false)

      patch :update_owner, :params => { :station => { :owner_id => '' } }
    end

    it { should redirect_to(root_back_url) }

    it { should set_flash[:error] }
  end

  describe "DELETE :destroy" do

    before do
      login(create(:station, :owner_id => user.id), user)
      @request.host = "#{@station.url}.test.local"

      delete :destroy
    end

    it { should redirect_to("http://www.test.local/bye") }
  end
end
