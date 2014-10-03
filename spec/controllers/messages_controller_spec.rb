# -*- encoding : utf-8 -*-
require 'rails_helper'

describe MessagesController do

  setup(:activate_authlogic)

  context "an user logged in" do

    before(:each) do
      login
    end

    let(:message) { create(:message, :user => @user) }

    describe "GET :index" do

      before(:each) do
        get :index
      end

      it { should respond_with(:success) }
      it { should render_template("index") }
      it { should render_with_layout("back") }

      it { expect(assigns(:messages)).to_not be_nil}
    end

    describe "GET :show for a non existing message" do

      before(:each) do
        get :show, :id => 2458437589
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(messages_path) }

      it { should set_the_flash.level(:error) }
    end

    describe "GET :show on existing message" do

      before(:each) do
        get :show, :id => message.id
      end

      it { should respond_with(:success) }
      it { should render_template("show") }
      it { should render_with_layout("back") }
    end

    describe "POST :mark_as_read on existing message" do

      before(:each) do
        xhr :post, :mark_as_read, :id => message.id
      end

      it { should respond_with(:success) }
      it { should render_template("mark_as_read") }
      it { should_not render_with_layout }

      it "mark message as read" do
        assert(assigns(:message).read?)
      end
      it "fade out message" do
        assert_match(@response.body, "fadeOut")
        assert_match(@response.body, "#message_#{message.id}")
      end
    end
  end
end
