require 'test_helper'

class ConvocationTest < ActiveSupport::TestCase
  
  should_validate_presence_of(:title, :message => /titre/)
  should_validate_presence_of(:date, :message => /date/)
  should_validate_presence_of(:uniform, :message => /tenue/)
  should_validate_presence_of(:firemen, :message => /personnes/)  
  
  context "with an instance" do
    setup do
      @convocation = make_convocation_with_firemen(:date => 3.days.from_now, 
                                                   :station => Station.make)
    end

    should "be valid" do
      assert(@convocation.valid?)
    end

    should "be editable" do
      assert(@convocation.editable?)
    end

    context "and date in past" do
      setup do
        @convocation.date = 3.weeks.ago
      end

      should "not be valid" do
        assert_equal(false, @convocation.valid?)
      end

      should "not be editable" do
        assert_equal(false, @convocation.editable?)
      end
    end
  end
end
