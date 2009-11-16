require 'test_helper'

class GradeTest < ActiveSupport::TestCase

  context "new_defaults" do
    setup do
      @grades = Grade::new_defaults
    end
    
    should "initialize grades" do
      assert_equal(Grade::GRADE.size, @grades.size)
    end
  end
end
