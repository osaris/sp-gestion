# -*- encoding : utf-8 -*-
require 'rails_helper'

describe ConvocationFiremenController do

  setup(:activate_authlogic)

  context "an user not logged in" do

    before(:each) do
      @station = create(:station, :url => 'cis-test')
      @request.host = 'cis-test.sp-gestion.fr'
    end

    let(:conv_conf) { create(:convocation, :station => @station,
                                           :confirmable => true) }

    let(:conv_not_conf) { create(:convocation, :station => @station,
                                               :confirmable => false) }

    describe "GET :accept on non existing convocation" do

      before(:each) do
        get :accept, :convocation_id => -1, :id => -1
      end

      it { should respond_with(:success) }
      it { should render_with_layout("login") }

      it { should set_the_flash.level(:error).now }
    end

    describe "GET :accept on a confirmable and non editable convocation" do

      before(:each) do
        allow_any_instance_of(ConvocationValidator).to receive(:validate).and_return(true)
        allow_any_instance_of(Convocation).to receive(:editable?).and_return(false)

        get :accept, :convocation_id => Digest::SHA1.hexdigest(conv_conf.id.to_s),
                     :id => Digest::SHA1.hexdigest(conv_conf.convocation_firemen.first.id.to_s)
      end

      it { should respond_with(:success) }
      it { should render_with_layout("login") }

      it { should set_the_flash.level(:error).now }
    end

    describe "GET :accept on a confirmable convocation" do

      before(:each) do
        get :accept, :convocation_id => Digest::SHA1.hexdigest(conv_conf.id.to_s),
                     :id =>Digest::SHA1.hexdigest(conv_conf.convocation_firemen.first.id.to_s)
      end

      it { should respond_with(:success) }
      it { should render_with_layout("login") }

      it { should set_the_flash.level(:success).now }
    end

    describe "GET :accept on a non confirmable and non editable convocation" do

      before(:each) do
        allow_any_instance_of(ConvocationValidator).to receive(:validate).and_return(true)
        allow_any_instance_of(Convocation).to receive(:editable?).and_return(false)

        get :accept, :convocation_id => Digest::SHA1.hexdigest(conv_not_conf.id.to_s),
                     :id => Digest::SHA1.hexdigest(conv_not_conf.convocation_firemen.first.id.to_s)
      end

      it { should respond_with(:success) }
      it { should render_with_layout("login") }

      it { should set_the_flash.level(:error).now }
    end

    describe "GET :accept on a non confirmable convocation" do

      before(:each) do
        get :accept, :convocation_id => Digest::SHA1.hexdigest(conv_not_conf.id.to_s),
                     :id =>Digest::SHA1.hexdigest(conv_not_conf.convocation_firemen.first.id.to_s)
      end

      it { should respond_with(:success) }
      it { should render_with_layout("login") }

      it { should set_the_flash.level(:error).now }
    end
  end

  context "an user logged in" do

    before(:each) do
      login
    end

    let(:convocation) { create(:convocation, :station => @station) }

    describe "GET :edit on non existing convocation" do

      before(:each) do
        get :edit_all, :convocation_id => 10
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(convocations_path) }

      it { should set_the_flash.level(:error) }
    end

    describe "GET :edit_all" do

      before(:each) do
        get :edit_all, :convocation_id => convocation.id
      end

      it { should respond_with(:success) }
      it { should render_template("edit_all") }
      it { should render_with_layout("back") }

      it { expect(assigns(:convocation)).to_not be_nil }
      it { expect(assigns(:convocation_firemen)).to_not be_nil }
    end

    describe "GET :show with PDF format" do

      before(:each) do
        @request.env["SERVER_PROTOCOL"] = "http"

        get :show, :convocation_id => convocation.id, :id => convocation.convocation_firemen.first.id, :format => 'pdf'
      end

      it { should respond_with(:success) }
      it { should render_template("show") }
      it "send a file" do
        send_file_to_disk(@response.body, "convocation_unique.pdf")
      end
    end

    describe "GET :show_all with PDF format" do

      before(:each) do
        @request.env["SERVER_PROTOCOL"] = "http"

        get :show_all, :convocation_id => convocation.id, :format => 'pdf'
      end

      it { should respond_with(:success) }
      it { should render_template("show_all") }
      it "send a file" do
        send_file_to_disk(@response.body, "liste_appel.pdf")
      end
    end

    describe "PATCH :update_all" do

      before(:each) do
        convocation_firemen_id = convocation.convocation_firemen.first.id

        post :update_all, :convocation_id => convocation.id, :convocation_firemen => { convocation_firemen_id.to_s => {:presence => 1 }}
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(convocation_path(assigns(:convocation))) }

      it { expect(assigns(:convocation)).to_not be_nil}
      it "set the presence of firemen" do
        assert(convocation.convocation_firemen.first.presence)
      end
      it { should set_the_flash.level(:success) }
    end
  end
end
