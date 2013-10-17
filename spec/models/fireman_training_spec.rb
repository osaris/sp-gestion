require 'spec_helper'

describe FiremanTraining do

  # force the subject because validate_uniqueness use data in database
  subject { FiremanTraining.make! }

  it { should validate_uniqueness_of(:training_id).with_message(/formation existe déjà/) }

  it { should validate_presence_of(:training_id) }

  it { should validate_presence_of(:achieved_at).with_message(/date est obligatoire/) }
end