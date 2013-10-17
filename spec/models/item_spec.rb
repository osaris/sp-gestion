require 'spec_helper'

describe Item do

  it { should belong_to(:check_list) }

  it { should validate_presence_of(:title).with_message(/titre/) }

  it { should validate_presence_of(:quantity).with_message(/quantité/) }
end
