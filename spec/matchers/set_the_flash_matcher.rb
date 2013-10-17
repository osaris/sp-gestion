# -*- encoding : utf-8 -*-
module Shoulda # :nodoc:
  module Matchers
    module ActionController # :nodoc:

      class SetTheFlashMatcher # :nodoc:

        def level(value)
          @level = value
          self
        end

        def matches?(controller)
          @controller = controller
          sets_the_flash? && level_match? && string_value_matches? && regexp_value_matches?
        end

        private

        def level_match?
          return true unless Symbol === @level
          !flash[@level].blank?
        end

        def expectation
          expectation = "the flash#{".now" if @now}"
          expectation << "[:#{@level}]" if @level
          expectation << " to be set"
          expectation << " to #{@value.inspect}" unless @value.nil?
          expectation << ", but #{flash_description}"
          expectation
        end
      end
    end
  end
end
