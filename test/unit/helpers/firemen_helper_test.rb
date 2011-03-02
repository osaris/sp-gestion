# -*- encoding : utf-8 -*-
require 'test_helper'

class FiremenHelperTest < ActionView::TestCase
  
  context "style_for_grades with status JSP" do
    setup do
      @style_for_grades = style_for_grades(Fireman.new(:status => 1))
    end

    should "render CSS to hide" do
      assert_equal("display:none;", @style_for_grades)
    end
  end
  
  context "styles_for_grades with other status" do
    setup do
      @style_for_grades = style_for_grades(Fireman.new(:status => 0))      
    end

    should "render nothing" do
      assert_equal("", @style_for_grades)
    end
  end
  
  context "class_for_grade with grade set" do
    setup do
      @class_for_grade = class_for_grade(Grade.new(:date => Time.now))
    end

    should "render CSS to set color" do
      assert_equal("set", @class_for_grade)
    end
  end
  
  context "class_for_grade with grade not set" do
    setup do
      @class_for_grade = class_for_grade(Grade.new(:date => nil))      
    end

    should "render nothing" do
      assert_equal("", @class_for_grade)
    end
  end
end
