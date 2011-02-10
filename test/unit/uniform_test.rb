require 'test_helper'

class UniformTest < ActiveSupport::TestCase

  should validate_presence_of(:title).with_message(/titre/)
  should validate_presence_of(:description).with_message(/description/)

  context "with an instance" do
    setup do
      @uniform = Uniform.make
    end

    should "be valid" do
      assert(@uniform.valid?)
    end

    context "used in a convocation" do
      setup do
        make_convocation_with_firemen(:uniform => @uniform, :station => Station.make!)
      end

      should "not be destroyable" do
        assert_equal(false, @uniform.destroy)
      end
    end
  end
end
