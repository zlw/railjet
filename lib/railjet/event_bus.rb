module Railjet
  module Publisher
    def self.included(klass)
      raise "Railjet::EventBus adapter must be specified" unless Railjet::EventBus.adapter

      klass.__send__(:include, Railjet::EventBus.publisher)
      klass.__send__(:include, CustomSubscription)
    end

    module CustomSubscription
      def subscribe(event, subscriber)
        super(subscriber, on: event, prefix: true)
      end
    end
  end

  class EventBus
    class << self
      attr_accessor :adapter
      delegate :publisher, to: :adapter
    end

    def initialize(adapter: self.class.adapter)
      @bus = adapter or raise ArgumentError, "Railjet::EventBus adapter must be specified"
    end

    def subscribe(event, subscriber)
      bus.subscribe(subscriber, on: event, prefix: true, async: true)
    end

    private

    attr_reader :bus

    module Testing
      require "wisper/testing"

      class << self
        delegate :adapter, to: EventBus
        delegate :clear,   to: :adapter
        delegate :inline,  to: :testing

        def testing
          adapter::Testing
        end
      end
    end
  end
end