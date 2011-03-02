# -*- encoding : utf-8 -*-
require 'test_helper'

class ItemTest < ActiveSupport::TestCase

  should validate_presence_of(:title).with_message(/titre/)
  should validate_presence_of(:quantity).with_message(/quantité/)

end
