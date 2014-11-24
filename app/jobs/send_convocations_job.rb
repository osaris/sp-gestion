class SendConvocationsJob < ActiveJob::Base
  queue_as :default

  def perform(convocation, user)
    convocation.send_emails(user.email)
  end
end
