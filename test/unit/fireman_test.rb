require 'test_helper'

class FiremanTest < ActiveSupport::TestCase
    
  context "with an instance" do
    setup do
      @fireman = Fireman.new(:firstname => 'Test', :lastname => 'Test')
    end
    
    should "initialize status to actif" do
      assert_equal(Fireman::STATUS['Actif'], @fireman.status)
    end
    
    should "initialize grades" do
      assert_equal(Grade::GRADE.size, @fireman.grades.size)
    end
    
    should "not be valid" do
      assert_equal(false, @fireman.valid?)
    end
      
    context "and a grade set" do
      setup do
        @fireman.grades.last.date = Date.today - 3.weeks
      end
      
      should "return current_grade" do
        assert_equal(Grade::GRADE['2e classe'], @fireman.current_grade.kind)
      end
      
      should "be valid" do
        assert(@fireman.valid?)
      end
      
      context "saved" do
        setup do
          @fireman.save
        end

        should "be denormalized" do
          assert_equal(Grade::GRADE_CATEGORY['Homme du rang'], @fireman.grade_category)
          assert_equal(Grade::GRADE['2e classe'], @fireman.grade)
        end
      end
    end
  end
end
