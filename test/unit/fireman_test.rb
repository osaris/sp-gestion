require 'test_helper'

class FiremanTest < ActiveSupport::TestCase
      
  context "with an instance and station last_grade_update_at nil" do
    setup do
      @fireman = Fireman.new(:firstname => 'Test', :lastname => 'Test', :station => Station.make)
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
    
    should "return nil for current_grade" do
      assert_nil(@fireman.current_grade)
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
      
      context "and a convocation" do
        setup do
          @fireman.convocations << Convocation.make_unsaved
        end
        
        should "not be destroyable" do
          assert_equal(false, @fireman.destroy)
        end
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
  
  context "with an instance and last_grade_update_at" do
    setup do
      @station = Station.make(:last_grade_update_at => 2.days.ago)
      @fireman = Fireman.new(:firstname => 'Test', :lastname => 'Test', :station => @station)
    end

    context "update a grade after last_grade_update_at" do
      setup do
        @fireman.grades.first.date = Date.today
      end
      
      should "sucessfuly save without validate_grade_update" do
        assert_equal(true, @fireman.save)
      end
    end
  end
  
  
  context "with an instance and station last_grade_update_at set and intervention" do
    setup do
      @station = Station.make(:last_grade_update_at => 2.days.ago)
      make_intervention_with_firemen(:station => @station)
      @fireman = Fireman.new(:firstname => 'Test', :lastname => 'Test', :station => @station)
    end
    
    context "update a grade after last_grade_update_at" do
      setup do
        @fireman.grades.first.date = Date.today
      end
      
      should "fail save without validate_grade_update" do
        assert_equal(false, @fireman.save)
      end
      
      should "successfuly save with validate_grade_update" do
        @fireman.validate_grade_update = 1
        assert_equal(true, @fireman.save)
      end
    end
  end
end