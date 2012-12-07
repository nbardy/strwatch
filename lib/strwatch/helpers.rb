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

      # Set up mustache rendering if block is given 
      if block_given?
        # Set template inside of a script to get around the lack of multiline strings in javascript. Shame on you javascript.
        mustache_template =
          """
          <script id='strwatch-template-#{name}' type='text/html'>
            #{capture(&block)}
          </script>
          """

        # Create javascript used to render the template
        render = "var out = Mustache.to_html(template, view);"

        # First rendering using non streamed data and setting up template
        initial_render = 
          """
          var template = document.getElementById('strwatch-template-#{name}').innerHTML;
          var view = #{initial_data.to_json};
          #{render}
          """

        # Rendering using data recieved from Server Side Events
        data_response = 
          """
          var view = JSON.parse(event.data);
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
        #{mustache_template}
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
