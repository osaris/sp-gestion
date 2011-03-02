# -*- encoding : utf-8 -*-
require 'test_helper'

class CheckListTest < ActiveSupport::TestCase

  should validate_presence_of(:title).with_message(/titre/)

  context "with an instance" do
    setup do
      @cl = make_check_list_with_items()
    end

    context "copy" do
      setup do
        @cl_copy = @cl.copy
      end

      should "return a copy with different title" do
        assert_match(@cl.title, @cl_copy.title)
      end

      should "return a copy having same number of items" do
        assert_equal(@cl_copy.items.size, @cl.items.size)
      end
    end
  end

end
