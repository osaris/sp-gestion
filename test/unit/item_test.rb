require 'test_helper'

class ItemTest < ActiveSupport::TestCase

  should_validate_presence_of(:title, :message => /titre/)
  should_validate_presence_of(:quantity, :message => /quantité/)

end
