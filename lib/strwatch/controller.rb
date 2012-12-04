require 'action_controller'

module StrWatch
  module Controller
    extend ActiveSupport::Concern

    module ClassMethods
      def self

      end
    end
  end
end

# Include streaming functions in ActionController::Base
class ActionController::Base
  include StrWatch::Controller
end
