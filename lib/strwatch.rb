require "strwatch/version"

# Include helper functions in ActiveRecord::Base
# These will watch the models for changes
class ActiveRecord::Base
  include StrWatch::Model
end

# Include streaming functions in ActionController::Base
class ActionController::Base
  include StrWatch::Controller
end
