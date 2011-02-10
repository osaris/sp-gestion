require 'test_helper'

class ConvocationsControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "an user logged in" do
    setup do
      login
      @uniform = Uniform.make!
      @fireman = make_fireman_with_grades(:station => @station)
    end

    context "requesting GET :index" do
      setup do
        get :index
      end

      should respond_with(:success)
      should render_template("index")
      should render_with_layout("back")

      should assign_to(:convocations)
    end

    context "requesting GET :show for a non existing convocation" do
      setup do
        get :show, :id => 2458437589
      end

      should respond_with(:redirect)
      should redirect_to(":index") { convocations_path }

      should set_the_flash.level(:error)
    end

    context "requesting GET :new" do
      setup do
        get :new
      end

      should respond_with(:success)
      should render_template("new")
      should render_with_layout("back")
    end

    context "requesting POST :create with bad data" do
      setup do
        post :create, :convocation => {:title => '', :date => '', :place => '', :uniform_id => '', :fireman_ids => []}
      end

      should respond_with(:success)
      should render_template("new")
      should render_with_layout("back")
    end

    context "requesting POST :create with good data" do
      setup do
        post :create, :convocation => {:title => "Test", :date => I18n.localize(2.weeks.from_now), :place => "Test lieu",
                                       :fireman_ids => [@fireman.id.to_s], :uniform_id => @uniform.id.to_s}
      end

      should respond_with(:redirect)
      should redirect_to("convocation") { convocation_path(assigns(:convocation)) }

      should set_the_flash.level(:success)
    end

    context "with an existing convocation not editable" do
      setup do
        @convocation = make_convocation_with_firemen(:station => @station)
        stub.instance_of(Convocation).editable? { false }
      end

      context "requesting GET :edit" do
        setup do
          get :edit, :id => @convocation.id
        end

        should respond_with(:redirect)
        should redirect_to("convocation") { convocation_path(assigns(:convocation)) }

        should set_the_flash.level(:error)
      end

      context "requesting PUT :update with good data" do
        setup do
          put :update, :id => @convocation.id, :convocation => {:title => "Test", :date => I18n.localize(2.weeks.from_now), :place => "Test lieu",
                                                                :fireman_ids => [@fireman.id.to_s], :uniform_id => @uniform.id.to_s}
        end

        should respond_with(:redirect)
        should redirect_to("convocation") { convocation_path(assigns(:convocation)) }

        should set_the_flash.level(:error)
      end
    end

    context "with an existing convocation" do
      setup do
        @convocation = make_convocation_with_firemen(:station => @station)
      end

      context "requesting GET :show on existing convocation" do
        setup do
          get :show, :id => @convocation.id
        end

        should respond_with(:success)
        should render_template("show")
        should render_with_layout("back")

        should assign_to(:convocation)
      end

      context "requesting GET :show on existing convocation with PDF format" do
        setup do
          @request.env["SERVER_PROTOCOL"] = "http"
          get :show, :id => @convocation.id, :format => 'pdf'
        end

        should respond_with(:success)
        should render_template("show")
        should "send a file" do
          send_file_to_disk(@response.body, "convocation.pdf")
        end
      end

      context "requesting GET :edit" do
        setup do
          get :edit, :id => @convocation.id
        end

        should respond_with(:success)
        should render_template("edit")
        should render_with_layout("back")
      end

      context "requesting PUT :update with bad data" do
        setup do
          put :update, :id => @convocation.id, :convocation => {:title => "", :date => I18n.localize(2.weeks.from_now), :place => "",
                                                                :fireman_ids => [@fireman.id.to_s], :uniform_id => @uniform.id.to_s}
        end

        should respond_with(:success)
        should render_template("edit")
        should render_with_layout("back")
      end

      context "requesting PUT :update with good data" do
        setup do
          put :update, :id => @convocation.id, :convocation => {:title => "Test", :date => I18n.localize(2.weeks.from_now), :place => "Test lieu",
                                                                :fireman_ids => [@fireman.id.to_s], :uniform_id => @uniform.id.to_s}
        end

        should respond_with(:redirect)
        should redirect_to("convocation") { convocation_path(assigns(:convocation)) }

        should set_the_flash.level(:success)
      end

      context "requesting DELETE :destroy" do
        setup do
          delete :destroy, :id => @convocation.id
        end

        should redirect_to("convocations list") { convocations_path }

        should set_the_flash.level(:success)
      end

      context "requesting POST :email with email quota not exceeded" do
        setup do
          stub.instance_of(Station).can_send_email? { true }
          post :email, :id => @convocation.id
        end

        should respond_with(:redirect)
        should redirect_to("convocation") { convocation_path(assigns(:convocation)) }

        should set_the_flash.level(:success)
      end

      context "requesting POST :email with email quota exceeded" do
        setup do
          stub.instance_of(Station).can_send_email? { false }
          post :email, :id => @convocation.id
        end

        should respond_with(:redirect)
        should redirect_to("convocation") { convocation_path(assigns(:convocation)) }

        should set_the_flash.level(:error)
      end
    end
  end
end
