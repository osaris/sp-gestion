require 'rails_helper'

describe FiremanTrainingsController do

  setup(:activate_authlogic)

  context "an user logged in with an existing fireman and an existing training" do

    before(:each) do
      login
    end

    let(:fireman) { create(:fireman, :station => @station) }

    let(:training) { create(:training, :station => @station) }

    let(:fireman_training) {
      fireman.fireman_trainings.create(:training_id => training.id,
                                       :achieved_at => 2.days.ago)
    }

    describe "GET :index for a non existing fireman" do

      before(:each) do
        get :show, :params => { :fireman_id => -1, :id => -1 }
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(firemen_path) }

      it { should set_flash[:error] }
    end

    describe "GET :index" do

      before(:each) do
        get :index, :params => { :fireman_id => fireman.id }
      end

      it { should respond_with(:success) }
      it { should render_template("index") }
      it { should render_with_layout("back") }

      it { expect(assigns(:fireman)).to_not be_nil}
    end

    describe "GET :new" do

      before(:each) do
        get :new, :params => { :fireman_id => fireman.id }
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("back") }
    end

    describe "POST :create with bad data" do

      before(:each) do
        post :create, :params => { :fireman_id => fireman.id, :fireman_training => {:achieved_at => ''} }
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("back") }
    end

    describe "POST :create with good data" do

      before(:each) do
        post :create, :params => { :fireman_id => fireman.id, :fireman_training => { :training_id => training.id.to_s,
                                                                        :achieved_at => I18n.localize(2.days.ago) } }
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(fireman_fireman_training_path(assigns(:fireman), assigns(:fireman_training))) }

      it { expect(assigns(:fireman_training)).to_not be_nil}
      it { expect(assigns(:fireman)).to_not be_nil}
      it { should set_flash[:success] }
    end

    describe "GET :show for a non existing training on an existing fireman" do

      before(:each) do
        get :show, :params => { :fireman_id => fireman.id, :id => -1 }
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(fireman_fireman_trainings_path(assigns(:fireman))) }

      it { should set_flash[:error] }
    end

    describe "GET :edit" do

      before(:each) do
        get :edit, :params => { :fireman_id => fireman.id, :id => fireman_training.id }
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("back") }
    end

    describe "PATCH :update with bad data" do

      before(:each) do
        patch :update, :params => { :fireman_id => fireman.id, :id => fireman_training.id,
                                                 :fireman_training => {
                                                    :training_id => training.id.to_s,
                                                    :achieved_at => ''
                                                 }
        }
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("back") }
    end

    describe "PATCH :update with good data" do

      before(:each) do
        patch :update, :params => { :fireman_id => fireman.id, :id => fireman_training.id,
                                                 :fireman_training => {
                                                    :training_id => training.id.to_s,
                                                    :achieved_at => I18n.localize(10.days.ago)
                                                 }
        }
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(fireman_fireman_training_path(assigns(:fireman), assigns(:fireman_training))) }

      it { should set_flash[:success] }
    end

    describe "DELETE :destroy" do

      before(:each) do
        delete :destroy, :params => { :fireman_id => fireman.id, :id => fireman_training.id }
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(fireman_fireman_trainings_path(assigns(:fireman))) }

      it { should set_flash[:success] }
    end
  end
end
