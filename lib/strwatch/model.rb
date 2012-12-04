require 'active_support/concern'
require 'active_record'

module StrWatch
  module Model
    extend ActiveSupport::Concern

    included do
      attr_accessor :strwatch_callback

      set_callback :save, :after do |record|
        record.strwatch_callback.call unless record.strwatch_callback.nil?
      end
    end

    module ClassMethods

    end
  end
end

# Include helper functions in ActiveRecord::Base
# These will watch the models for changes
class ActiveRecord::Base
  include StrWatch::Model
end
