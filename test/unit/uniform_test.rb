require 'test_helper'

class UniformTest < ActiveSupport::TestCase

  should_validate_presence_of(:title, :message => /titre/)
  should_validate_presence_of(:description, :message => /description/)

end
