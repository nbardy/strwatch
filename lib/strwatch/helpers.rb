require 'action_controller'
require 'strwatch/connection'

module Strwatch
  module Helpers
    extend ActiveSupport::Concern
    
    def stream(name, options={})
      url = "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
      streaming_url = url +
        "?#{STREAMING_PARAM}=true"

      id = "strwatch-content-#{name}"

      # Handle options
      #
      # Can accept the name of a javascript function to preform formatting
      # before the data is inserted.
      # Useful for passing json instead of html
      if options[:js_format]
        # If argument is passed wrap data in function call
        data = "#{params[:js_format]}(event.data)"
      else
        data = "event.data"
      end

      """
      <div id=\"#{id}\">
      </div>
      <script>
        var source = new EventSource(#{streaming_url});
        source.addEventListener('strwatch-#{name}', function(event) {
          $(\"##{id}\").html(#{data});
        });
      </script> 
      """
    end
  end
end

ActionView::Base.send :include, Strwatch::Helpers
