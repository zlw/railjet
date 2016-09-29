module OnsContext
  module UseCase
    extend ActiveSupport::Concern

    attr_reader :context

    def initialize(context)
      @context = context
    end

    def with_ability_check(*args)
      if check_ability!(*args)
        yield if block_given?
      else
        raise OnsContext::UnauthorizedError
      end
    end

    def with_policy_check(*args)
      check_policy!(*args)
      yield if block_given?
    rescue OnsContext::PolicyError => e
      raise OnsContext::PolicyNotMetError.new(e.errors)
    end

    def check_ability!(*args)
      true
    end

    def check_policy!(*args)
      true
    end

    def use_case(klass)
      klass.new(context)
    end

    def policy(klass, *args)
      klass.new(context, *args).validate!
    end

    module ClassMethods
      def context(*context_members)
        delegate *context_members, to: :context
      end

      def check_ability(ability_name)
        define_method :check_ability! do |*args|
          context.current_ability.send(ability_name, *args)
        end
      end

      def check_policy(&block)
        define_method :check_policy!, &block
      end
    end
  end
end