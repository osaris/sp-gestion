require 'test_helper'

class UniformTest < ActiveSupport::TestCase

  should_validate_presence_of(:title, :message => /titre/)
  should_validate_presence_of(:description, :message => /description/)

  context "with an instance" do
    setup do
      @uniform = Uniform.make_unsaved
    end
    
    should "be valid" do
      assert(@uniform.valid?)
    end
    
    context "used in a convocation" do
      setup do
        make_convocation_with_firemen(:uniform => @uniform)
      end
      
      should "not be destroyable" do
        assert_equal(false, @uniform.destroy)
      end
    end
  end
end
