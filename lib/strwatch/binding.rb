module Strwatch
  # A class which holds a connection between client and server data
  # with respect to a certain var_name
  class Connection
    # Params:
    #  io: response.stream
    #  var_name: name of variable to be bound
    #
    def initialize io, var_name,
      @io = io
      @var_name = var_name
    end

    # Wraps the data in a configured strwatch hash 
    # Then output as json
    def write(data)
      out = { type: "strwatch", "str-var_name" => @var_name }
      out[@var_name] = data
      @io.write out.to_json
    end
  end
end
