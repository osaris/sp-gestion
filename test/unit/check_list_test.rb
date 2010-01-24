require 'test_helper'

class CheckListTest < ActiveSupport::TestCase

  should_validate_presence_of(:title, :message => /titre/)

end
