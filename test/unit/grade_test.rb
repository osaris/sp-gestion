require 'test_helper'

class GradeTest < ActiveSupport::TestCase
  
  context "an instance" do
    setup do
      @grade = Grade.new
    end

    should "be valid" do
      assert(@grade.valid?)
    end
    
    context "with date in future" do
      setup do
        @grade.date = 2.weeks.from_now
      end

      should "not be valid" do
        assert(!@grade.valid?)
      end
    end
  end
  
  context "new_defaults" do
    setup do
      @grades = Grade::new_defaults
    end
    
    should "initialize grades" do
      assert_equal(Grade::GRADE.size, @grades.size)
    end
  end
end
