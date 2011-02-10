module Shoulda # :nodoc:
  module Matchers
    module Custom # :nodoc:

      def be_logged_in
        BeLoggedInMatcher.new
      end

      class BeLoggedInMatcher # :nodoc:

        def matches?(controller)
          current_user_session = UserSession.find
          current_user_session != nil
        end

        attr_reader :failure_message, :negative_failure_message

        def description
          "be logged in"
        end

        def failure_message
          "Expected not to be logged in"
        end

        def negative_failure_message
          "Did not expect to be logged in"
        end

        private

        def expectation
          "to be logged in, but was logged in"
        end
      end
    end
  end
end