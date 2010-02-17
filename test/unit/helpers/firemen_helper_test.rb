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
  
  context "display_role for fireman with no role" do
    setup do
      @display_role = display_role(Fireman.new)
    end
    
    should "render a -" do
      assert_equal("-", @display_role)
    end
  end

  context "display_role for fireman with roles" do
    setup do
      @display_role = display_role(Fireman.new(:chief => true, :quartermaster => true))
    end

    should "render roles slash separated" do
      assert_match("/", @display_role)
    end
  end
end
