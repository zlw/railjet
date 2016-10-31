require "railjet/repository/active_record"
require "railjet/repository/cupido"

module Railjet
  module Repository
    extend  ::ActiveSupport::Concern

    attr_reader :registry
    delegate    :settings, to: :registry

    def initialize(registry, **kwargs)
      @registry = registry
      define_accessors(**kwargs)

      initialize_record_repository if respond_to?(:record, true)
      initialize_cupido_repository if respond_to?(:cupido, true)
    end

    private

    def define_accessors(**kwargs)
      kwargs.each do |name, val|
        repository_module.send(:define_method, name) { val }
        repository_module.send(:protected, name)
      end
    end

    def repository_module
      @repository_module ||= Module.new.tap { |m| self.class.include(m) }
    end

    def initialize_record_repository
      if defined?(self.class::ActiveRecordRepository)
        def self.record
          @record ||= self.class::ActiveRecordRepository.new(registry, super)
        end
      end
    end

    def initialize_cupido_repository
      if defined?(self.class::CupidoRepository)
        def self.cupido
          @cupido ||= self.class::CupidoRepository.new(registry, super)
        end
      end
    end
  end
end
