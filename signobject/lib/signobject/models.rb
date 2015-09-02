module Signobject
  module Models
    def self.config(mod, *accessors) #:nodoc:
      puts " *** COFIG SIGNOBJECT *** "
      class << mod; attr_accessor :available_configs; end
      mod.available_configs = accessors

      accessors.each do |accessor|
        puts "*** CONFIG ACCESSOR ***",accessor,accessor.class
        inp = $stdin.read
        mod.class_eval <<-METHOD, __FILE__, __LINE__ + 1
          def #{accessor}
            if defined?(@#{accessor})
              @#{accessor}
            elsif superclass.respond_to?(:#{accessor})
              superclass.#{accessor}
            else
              Signobject.#{accessor}
            end
          end

          def #{accessor}=(value)
            @#{accessor} = value
          end
        METHOD
      end
    end

    def self.check_fields!(klass)
      failed_attributes = []
      instance = klass.new

      klass.signobject_modules.each do |mod|
        constant = const_get(mod.to_s.classify)

        constant.required_fields(klass).each do |field|
          failed_attributes << field unless instance.respond_to?(field)
        end
      end

      if failed_attributes.any?
        fail Signobject::Models::MissingAttribute.new(failed_attributes)
      end
    end

    # Include the chosen devise modules in your model:
    #
    #   devise :database_authenticatable, :confirmable, :recoverable
    #
    # You can also give any of the devise configuration values in form of a hash,
    # with specific values for this model. Please check your Devise initializer
    # for a complete description on those values.
    #
    def signobject(*modules)
      puts "*** signobject method ***"
      options = modules.extract_options!.dup
      puts "options--",options
      selected_modules = modules.map(&:to_sym).uniq.sort_by do |s|
        Signobject::ALL.index(s) || -1  # follow Devise::ALL order
      end
      puts "selected_modules--",selected_modules
      signobject_modules_hook! do
        include Signobject::Models::Signable

        selected_modules.each do |m|
          mod = Signobject::Models.const_get(m.to_s.classify)

          if mod.const_defined?("ClassMethods")
            class_mod = mod.const_get("ClassMethods")
            extend class_mod

            if class_mod.respond_to?(:available_configs)
              available_configs = class_mod.available_configs
              available_configs.each do |config|
                next unless options.key?(config)
                send(:"#{config}=", options.delete(config))
              end
            end
          end

          include mod
        end

        self.signobject_modules |= selected_modules
        options.each { |key, value| send(:"#{key}=", value) }
      end
    end

    # The hook which is called inside devise.
    # So your ORM can include devise compatibility stuff.
    def signobject_modules_hook!
      yield
    end
  end
end

require 'signobject/models/signable'
