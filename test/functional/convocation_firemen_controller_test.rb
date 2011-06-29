# -*- encoding : utf-8 -*-
require 'test_helper'

class ConvocationFiremenControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "an user not logged in" do
    setup do
      @station = Station.make!(:url => 'cis-test')
      @request.host = 'cis-test.sp-gestion.fr'
    end

    context "requesting GET :accept on non existing convocation" do
      setup do
        get :accept, :convocation_id => -1, :id => -1
      end

      should respond_with(:success)
      should render_template("accept")
      should render_with_layout("login")

      should set_the_flash.level(:error).now
    end

    context "with an existing convocation confirmable" do
      setup do
        @convocation = make_convocation_with_firemen(:station => @station,
                                                     :confirmable => true)
      end

      context "requesting GET :accept on a non editable convocation" do
        setup do
          stub.instance_of(Convocation).editable? { false }
          get :accept, :convocation_id => Digest::SHA1.hexdigest(@convocation.id.to_s),
                       :id => Digest::SHA1.hexdigest(@convocation.convocation_firemen.first.id.to_s)
        end

        should respond_with(:success)
        should render_template("accept")
        should render_with_layout("login")

        should set_the_flash.level(:error).now
      end

      context "requesting GET :accept" do
        setup do
          get :accept, :convocation_id => Digest::SHA1.hexdigest(@convocation.id.to_s),
                       :id =>Digest::SHA1.hexdigest(@convocation.convocation_firemen.first.id.to_s)
        end

        should respond_with(:success)
        should render_template("accept")
        should render_with_layout("login")

        should set_the_flash.level(:success).now
      end
    end

    context "with an existing convocation not confirmable" do
      setup do
        @convocation = make_convocation_with_firemen(:station => @station,
                                                     :confirmable => false)
      end

      context "requesting GET :accept on a non editable convocation" do
        setup do
          stub.instance_of(Convocation).editable? { false }
          get :accept, :convocation_id => Digest::SHA1.hexdigest(@convocation.id.to_s),
                       :id => Digest::SHA1.hexdigest(@convocation.convocation_firemen.first.id.to_s)
        end

        should respond_with(:success)
        should render_template("accept")
        should render_with_layout("login")

        should set_the_flash.level(:error).now
      end

      context "requesting GET :accept" do
        setup do
          get :accept, :convocation_id => Digest::SHA1.hexdigest(@convocation.id.to_s),
                       :id =>Digest::SHA1.hexdigest(@convocation.convocation_firemen.first.id.to_s)
        end

        should respond_with(:success)
        should render_template("accept")
        should render_with_layout("login")

        should set_the_flash.level(:error).now
      end
    end
  end

  context "an user logged in" do
    setup do
      login
    end

    context "requesting GET :edit on non existing convocation" do
      setup do
        get :edit_all, :convocation_id => 10
      end

      should respond_with(:redirect)
      should redirect_to("convocations") { convocations_path }

      should set_the_flash.level(:error)
    end

    context "with an existing convocation" do
      setup do
        @convocation = make_convocation_with_firemen(:station => @station)
      end

      context "requesting GET :edit_all" do
        setup do
          get :edit_all, :convocation_id => @convocation.id
        end

        should respond_with(:success)
        should render_template("edit")
        should render_with_layout("back")

        should assign_to(:convocation)
        should assign_to(:convocation_firemen)
      end

      context "requesting GET :show with PDF format" do
        setup do
          @request.env["SERVER_PROTOCOL"] = "http"
          get :show, :convocation_id => @convocation.id, :id => @convocation.convocation_firemen.first.id, :format => 'pdf'
        end

        should respond_with(:success)
        should render_template("show")
        should "send a file" do
          send_file_to_disk(@response.body, "convocation_unique.pdf")
        end
      end

      context "requesting GET :show_all with PDF format" do
        setup do
          @request.env["SERVER_PROTOCOL"] = "http"
          get :show_all, :convocation_id => @convocation.id, :format => 'pdf'
        end

        should respond_with(:success)
        should render_template("show")
        should "send a file" do
          send_file_to_disk(@response.body, "liste_appel.pdf")
        end
      end

      context "requesting PUT :update_all" do
        setup do
          convocation_firemen_id = @convocation.convocation_firemen.first.id
          post :update_all, :convocation_id => @convocation.id, :convocation_firemen => { convocation_firemen_id.to_s => {:presence => 1 }}
        end

        should respond_with(:redirect)
        should redirect_to("convocation") { convocation_path(assigns(:convocation)) }

        should assign_to(:convocation)
        should "set the presence of firemen" do
          assert(@convocation.convocation_firemen.first.presence)
        end
        should set_the_flash.level(:success)
      end
    end
  end
end
