require 'action_controller'
require 'strwatch/connection'

module Strwatch
  module Controller
    extend ActiveSupport::Concern

    included do
      include ActionController::Live
    end

    ## Creates a binding on an ActiveModel record using after_save callbacks
    #
    # stream_callback = 
    #   stream_callback :event do
    #     Event.get(params[:id])
    #   end
    #
    # Event.after_save = stream_callback
    #
    def stream_callback(name, options = {}, &block)
      if not block
        throw ArgumentError
      end

      # Set instance variable for original rendering before streaming is established
      instance_variable_set("@#{name}", block.call)

      response.headers['Content-Type'] = 'text/event-stream'

      connection = Strwatch::Connection.new(response.stream, name)

      lambda { connection.stream(block.call, options) }
    end

    def dirty_binding(name, options = {}, &block)
      if not block
        throw ArgumentError
      end
      # Set instance variable for original rendering before streaming is established
      instance_variable_set("@#{name}", block.call)

      # Check if the request is initial or for streaming content
      #
      # If the request is not for streaming ignore the rest of the code
      unless params[STREAMING_PARAM]
        return false
      else
        ## Handle options
        #
        # Default interval is 5
        interval = options[:interval] || 5

        # Has the client keep the connection open
        response.headers['Content-Type'] = 'text/event-stream'

        connection = Strwatch::Connection.new(response.stream, name)

        begin
          loop do 
            data = block.call
            connection.stream(data, options)
            sleep interval
          end
        rescue IOError # When client disconnects

        ensure
          connection.close
        end
      end
    end
  end
end
