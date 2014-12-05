require 'rails_helper'

describe PagesController do

  describe "GET :home" do

    before(:each) do
      get :home
    end

    it { should respond_with(:success) }
    it { should render_template("home") }
    it { should render_with_layout("front") }
  end

end
