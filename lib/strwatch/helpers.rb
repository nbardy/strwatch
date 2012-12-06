require 'action_controller'
require 'strwatch/connection'

module Strwatch
  module Helpers
    extend ActiveSupport::Concern
    
    def stream(name, options={}, &block)
      url = "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
      streaming_url = url +
        "?#{STREAMING_PARAM}=true"

      id = "strwatch-content-#{name}"

      # Get initial variable from @"name" instance variable set by controller
      initial_data = instance_variable_get("@#{name}")
      puts "initial_data: #{initial_data}"

      # Set up mustache rendering if block is given 
      if block_given?
        puts "block: #{capture(&block)}"

        render = "var out = Mustache.render(\"#{capture(&block)}\", view);"
        initial_render = 
          """
          var view = #{initial_data.to_json};
          #{render}
          """

        data_response = 
          """
          var view = event.data;
          #{render}
          """
      else
        initial_render = "var out = #{initial_data};"
        data_response = "var out = event.data;"
      end

      output = 
        """
        <div id=\"#{id}\">
        </div>
        <script>
          var source = new EventSource(\"#{streaming_url}\");
          #{initial_render}
          $(\"##{id}\").html(out);

          source.addEventListener('strwatch-#{name}', function(event) {
            #{data_response}
            $(\"##{id}\").html(out);
          });
        </script> 
        """.html_safe

        concat(output)
    end
  end
end

ActionView::Base.send :include, Strwatch::Helpers
