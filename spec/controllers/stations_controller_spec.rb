require 'rails_helper'

describe StationsController do

  describe "GET :new" do

    before(:each) do
      get :new
    end

    it { should respond_with(:success) }
    it { should render_template("new") }
    it { should render_with_layout("front") }
  end

  describe "POST :create with bad data" do

    before(:each) do
      post :create, :station => {:name => 'test', :url => 'él3 ek'},
                    :user => {:email => 'raphael', :password => '213', :password_confirmation => '123'}
    end

    it { should respond_with(:success) }
    it { should render_template("new") }
    it { should render_with_layout("front") }
  end

  describe "POST :create with good data" do

    before(:each) do
      post :create, :station => attributes_for(:station), :user => attributes_for(:user)
    end

    it { should respond_with(:success) }
    it { should render_template("create") }
    it { should render_with_layout("front") }

    it "adds a message to the default user" do
      assert_equal(1, assigns(:user).messages.length)
    end
  end

  describe "POST :check with existing station" do

    before(:each) do
      allow(Station).to receive(:check).and_return(create(:station))

      xhr :post, :check, :station => { :name => 'test' }
    end

    it { should respond_with(:success) }
    it { should render_template("check") }
    it { should_not render_with_layout }

    it { expect(assigns(:station)).to_not be_nil}
    it "shows name_warning" do
      assert_match(@response.body, "show")
    end
  end

   describe "POST :check with non existing station" do

    before(:each) do
      allow_any_instance_of(Station).to receive(:check).and_return(nil)

      xhr :post, :check, :station => { :name => 'test' }
    end

    it { should respond_with(:success) }
    it { should render_template("check") }
    it { should_not render_with_layout }

    it "assigns nil to @station" do
      assert_nil(assigns(:station))
    end
    it "hides name_warning" do
      assert_match(@response.body, "hide")
    end
  end

end
