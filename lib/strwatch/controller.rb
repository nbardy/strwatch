require 'action_controller'

module StrWatch
  module Controller
    extend ActiveSupport::Concern

    module ClassMethods

      # Creates a binding between an activerecord model
      #
      ###############
      ### Example ###
      ###############
      #
      # bind_one :event do
      #  Event.find(params[:id])
      # end
      #
      def bind_one(name, &block)
        
      end

      # Binds many objects to the variable given
      #
      # bind_many Event, :events do
      #   Event.all
      # end
      def bind_many(models, name, &block)

      end


      # Creates a dirty binding which uses a polling interview
      # This however decouples it from activerecord
      #
      # dirty_binding :variable do
      #   10000000 * rand   
      # end
      #
      def dirty_binding(name, &block)

      end
      
      def render_stream(view, streams*)
      
      end
    end
  end
end

# Include streaming functions in ActionController::Base
class ActionController::Base
  include StrWatch::Controller
end
