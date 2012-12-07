require 'action_controller'
require 'strwatch/connection'

module Strwatch
  module Controller
    extend ActiveSupport::Concern

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
    ###############
    ### Example ###
    ###############
    #
    # bind_many Event, :events do
    #   Event.all
    # end
    def bind_many(models, name, &block)

    end

    # Creates a dirty binding which uses a polling interview
    # This however decouples it from activerecord
    #
    # Accepts a variable name to bind the data to
    # an option hash:
    #     interval: time between dirty checks
    # block to evaluate and stream
    #
    # dirty_binding(:rand, interval: 4) do |x|
    #   "#{x}: #{10000000 * rand}"
    # end
    #
    def dirty_binding(name, options = {}, &block)
      # Set instance variable for original rendering before streaming is established
      instance_variable_set("@#{name}", block.call)

      # Check if the request is initial or for streaming content
      unless params[STREAMING_PARAM]
        return false
      end

      # Handle options
      
      # Default interval is 5
      interval = options[:interval] || 5

      # Wraps the data in a hash with its name as root
      wrap = options[:wrap] || false
      

      # Has the client keep the connection open
      response.headers['Content-Type'] = 'text/event-stream'

      connection = Strwatch::Connection.new(response.stream, name)

      begin
        loop do 
          data = block.call
          if wrap
            data = { name => data }
          end

          connection.stream data
          sleep interval
        end
      rescue IOError # When client disconnects

      ensure
        connection.close
      end
    end
  end
end
