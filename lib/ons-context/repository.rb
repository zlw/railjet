require "ons-context/repository/active_record_repository"
require "ons-context/repository/cupido_repository"

module OnsContext
  module Repository
    extend  ::ActiveSupport::Concern

    attr_reader :registry
    delegate    :settings, to: :registry

    def initialize(registry, **kwargs)
      @registry = registry
      define_accessors(kwargs)
    end

    private

    def define_accessors(kwargs)
      kwargs.each do |name, val|
        instance_variable_set("@#{name}", val)

        self.class.class_eval do
          attr_reader name
          private     name
        end
      end
    end
  end
end
