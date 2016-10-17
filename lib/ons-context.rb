require "ons-context/version"

require "active_support"
require "active_model"
require "active_model/merge_errors"
require "virtus"

module OnsContext
  Error             = Class.new(StandardError)
  UnauthorizedError = Class.new(Error)

  class ValidationError < Error
    attr_reader :errors

    def initialize(errors)
      @errors = errors
    end

    def error_messages
      errors.try(:messages)
    end
  end

  FormError   = Class.new(ValidationError)
  PolicyError = Class.new(ValidationError)
  PolicyNotMetError = Class.new(PolicyError)
end

require "ons-context/context"

require "ons-context/util/use_case_helper"
require "ons-context/util/policy_helper"
require "ons-context/util/form_helper"

require "ons-context/validator"
require "ons-context/form"
require "ons-context/policy"
require "ons-context/use_case"

require "ons-context/repository/registry"
require "ons-context/repository"

require "ons-context/railtie" if defined?(Rails)
