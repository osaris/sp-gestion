RSpec::Matchers.define :be_logged_in do |attribute|
  match do |actual|
    current_user_session = UserSession.find
    current_user_session != nil
  end

  failure_message_for_should do |actual|
    "Should be logged in."
  end

  failure_message_for_should_not do |actual|
    "Should not be logged in."
  end
end
