require 'active_support/concern'
require 'active_record'

module Strwatch
  module Model
    extend ActiveSupport::Concern

    included do
      attr_accessor :strwatch_callback

      set_callback :save, :after do |record|
        record.strwatch_callback.call unless record.strwatch_callback.nil?
      end
    end

    module ClassMethods
      def stream

      end
    end
    
    module InstanceMethods
      def stream

      end
    end
  end
end
