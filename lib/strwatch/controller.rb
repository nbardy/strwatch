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
      # Handle options
      interval = options[:interval] || 5

      # Has the client keep the connection open
      response.headers['Content-Type'] = 'text/event-stream'

      connection = Strwatch::Connection.new(response.stream, name)

      begin
        loop do 
          connection.write block.call
          sleep interval
        end
      rescue IOError # When client disconnects

      ensure
        connection.close
      end
    end
    
    def render_stream(view, streams)
    
    end
  end
end
