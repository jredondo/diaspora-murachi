require 'active_model/version'
#require 'devise/hooks/activatable'
#require 'devise/hooks/csrf_cleaner'

module Signobject
  module Models
    #
    module Signable
      extend ActiveSupport::Concern


      included do
        class_attribute :signobject_modules, instance_writer: false
        self.signobject_modules ||= []

        before_validation :downcase_keys
        before_validation :strip_whitespace
      end


      def signable?
        true
      end

      module ClassMethods
        puts "++++ Class Methods ++++ Signable Models"
        Signobject::Models.config(self, :signed)
      end
    end
  end
end
