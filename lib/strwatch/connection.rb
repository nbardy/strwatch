module Strwatch
  # A class which holds a connection between client and server data
  # with respect to a certain var_name
  class Connection
    # Params:
    #  io: response.stream
    #  var_name: name of variable to be bound
    #
    def initialize io, var_name
      @io = io
      @var_name = var_name
    end

    # Updates the stream with data
    def stream(data, options = {})
    # Wraps the data in a hash with its own name as root
    wrap = options[:wrap] ||= true

    # Handle options
      if options[:wrap]
        data = { @var_name => data }
      end

      write(data, :event => "strwatch-#{@var_name}")
    end

    # Closes the connection
    def close
      @io.close
    end

    # Writes a server side event accorind to this format
    # http://www.html5rocks.com/en/tutorials/eventsource/basics/
    #
    def write(data, options = {})
      unless data.is_a? String
        data = data.to_json
      end
      options.each do |k,v|
        @io.write "#{k}: #{v}\n"
      end
      @io.write "data: #{data}\n\n"
    end
  end
end
