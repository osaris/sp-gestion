require 'test_helper'

class ConvocationFiremanTest < ActiveSupport::TestCase
  
  context "with an instance of convocation, add a fireman and save" do
    setup do
      @fireman = make_fireman_with_grades()
      
      @convocation = Convocation.make_unsaved
      @convocation.firemen << @fireman
      @convocation.save
    end
    
    should "set the convocation_firemen grade to firemen grade" do
      assert_equal(@fireman.grade, @convocation.convocation_firemen.first.grade)
    end
    
    should "set the convocation_firemen status to firemen status" do
      assert_equal(@fireman.status, @convocation.convocation_firemen.first.status)
    end    
  end
    
end
