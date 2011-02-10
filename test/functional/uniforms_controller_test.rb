require 'test_helper'

class UniformsControllerTest < ActionController::TestCase
  setup(:activate_authlogic)

  context "an user logged in" do
    setup do
      login
    end

    context "requesting GET :index" do
      setup do
        get :index
      end

      should respond_with(:success)
      should render_template("index")
      should render_with_layout("back")

      should assign_to(:uniforms)
    end

    context "requesting GET :show for a non existing uniform" do
      setup do
        get :show, :id => rand(10)
      end

      should respond_with(:redirect)
      should redirect_to(":index") { uniforms_path }

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
        post :create, :uniform => {:title => '', :code => '2b', :description => 'test'}
      end

      should respond_with(:success)
      should render_template("new")
      should render_with_layout("back")
    end

    context "requesting POST :create with good data" do
      setup do
        post :create, :uniform => plan(Uniform.make)
      end

      should respond_with(:redirect)
      should redirect_to("uniform") { uniform_path(assigns(:uniform)) }

      should assign_to(:uniform)
      should set_the_flash.level(:success)
    end

    context "requesting POST :reset" do
      setup do
        post :reset
      end

      should respond_with(:redirect)

      should set_the_flash.level(:success)
    end

    context "with an existing uniform" do
      setup do
        @uniform = @station.uniforms.make!
      end

      context "requesting GET :show on existing uniform" do
        setup do
          get :show, :id => @uniform.id
        end

        should respond_with(:success)
        should render_template("show")
        should render_with_layout("back")
      end

      context "requesting GET :edit" do
        setup do
          get :edit, :id => @uniform.id
        end

        should respond_with(:success)
        should render_template("edit")
        should render_with_layout("back")
      end

      context "requesting PUT :update with bad data" do
        setup do
          put :update, :id => @uniform.id, :uniform => {:title => '', :code => '2b', :description => 'test'}
        end

        should respond_with(:success)
        should render_template("edit")
        should render_with_layout("back")
      end

      context "requesting PUT :update with good data" do
        setup do
          put :update, :id => @uniform.id, :uniform => plan(Uniform.make)
        end

        should respond_with(:redirect)
        should redirect_to("uniform") { uniform_path(assigns(:uniform)) }

        should set_the_flash.level(:success)
      end

      context "requesting DELETE :destroy without associations" do
        setup do
          delete :destroy, :id => @uniform.id
        end

        should redirect_to("uniforms list") { uniforms_path }

        should set_the_flash.level(:success)
      end

      context "requesting DELETE :destroy with associations" do
        setup do
          stub.instance_of(Uniform).destroy { false }
          stub.instance_of(Uniform).errors.stub!.full_messages { ["erreur"] }
          delete :destroy, :id => @uniform.id
        end

        should redirect_to("uniform") { uniform_path(assigns(:uniform)) }

        should set_the_flash.level(:error)
      end
    end
  end
end
