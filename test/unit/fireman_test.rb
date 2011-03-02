# -*- encoding : utf-8 -*-
require 'test_helper'

class FiremanTest < ActiveSupport::TestCase

  # test with no grade
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

    should "return nil for current_grade" do
      assert_nil(@fireman.current_grade)
    end

    should "return nil for max_grade_date" do
      assert_nil(@fireman.max_grade_date)
    end
  end

  # test grade
  context "with an instance and a grade set" do
    setup do
      @fireman = Fireman.new(:firstname => 'Test', :lastname => 'Test', :station => Station.make!)
      @fireman.grades.last.date = Date.today - 3.weeks
    end

    should "return current_grade" do
      assert_equal(Grade::GRADE['2e classe'], @fireman.current_grade.kind)
    end

    should "return max_grade_date" do
      assert_equal((Date.today - 3.weeks), @fireman.max_grade_date)
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

  # test destroy with relations
  context "with an instance valid and a convocation" do
    setup do
      @fireman = make_fireman_with_grades(:station => Station.make!, :convocations => [Convocation.make])
    end

    should "not be destroyable" do
      assert_equal(false, @fireman.destroy)
    end
  end

  context "with an instance valid and an intervention" do
    setup do
      @fireman = make_fireman_with_grades(:station => Station.make!, :interventions => [Intervention.make])
    end

    should "not be destroyable" do
      assert_equal(false, @fireman.destroy)
    end
  end


  # test validation for JSP
  context "with an instance JSP" do
    setup do
      @fireman = Fireman.new(:firstname => 'Test', :lastname => 'Test', :status => Fireman::STATUS['JSP'])
    end

    should "be valid" do
      assert(@fireman.valid?)
    end
  end

  # test validation for not JSP and no grade
  context "with an instance not JSP and no grade" do
    setup do
      @fireman = Fireman.new(:firstname => 'Test', :lastname => 'Test')
    end

    should "not be valid" do
      assert_equal(false, @fireman.valid?)
    end
  end

  # test validation for not JSP and grade and no change to last_grade_update_at
  context "with an instance not JSP and a grade" do
    setup do
      @fireman = make_fireman_with_grades(:station => Station.make!)
    end

    context "and last_grade_update_at will not be updated" do
      setup do
        stub.instance_of(Station).confirm_last_grade_update_at? { false }
      end

      should "be valid" do
        assert(@fireman.valid?)
      end
    end

    context "and last_grade_update_at will be updated but validate_grade_update is not set" do
      setup do
        @fireman.validate_grade_update = nil
        stub.instance_of(Station).confirm_last_grade_update_at? { true }
      end

      should "not be valid" do
        assert_equal(false, @fireman.valid?)
      end
    end

    context "and last_grade_update_at will be updated but validate_grade_update is set" do
      setup do
        @fireman.validate_grade_update = 1
        stub.instance_of(Station).confirm_last_grade_update_at? { true }
      end

      should "be valid" do
        assert(@fireman.valid?)
      end
    end
  end
end
