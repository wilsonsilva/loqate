require 'loqate/client'
require 'loqate/result'
require 'loqate/email_validation'
require 'loqate/batch_email_validation'
require 'loqate/mappers/error_mapper'
require 'loqate/mappers/generic_mapper'

module Loqate
  # Validates the existence of email addresses.
  #
  class EmailGateway
    BATCH_VALIDATE_ENDPOINT = '/EmailValidation/Batch/Validate/v1.20/json3.ws'.freeze
    VALIDATE_ENDPOINT = '/EmailValidation/Interactive/Validate/v2.00/json3.ws'.freeze

    include Result::Mixin

    # Creates an email gateway.
    #
    # @param [Client] client The client responsible for the HTTP interactions
    #
    def initialize(client)
      @client       = client
      @mapper       = Mappers::GenericMapper.new
      @error_mapper = Mappers::ErrorMapper.new
    end

    # Verifies the existence of an email address.
    #
    # @param [Hash] options The options to validate an email address.
    # @option options [String] :email The email address to verify.
    # @option options [Integer] :timeout The time (in milliseconds) you want to give for the validation attempt to be
    #   executed within. Value must be between 1 and 15000 (values outside of these ranges will fallback to the
    #   default of 15000).
    #
    # @example
    #   email_validation = email_gateway.validate(email: 'spam@example.com')
    #
    # @return [Result] A result wrapping an email address validation
    #
    def validate(options)
      response = client.get(VALIDATE_ENDPOINT, options)

      response.errors? && build_error_from(response.items.first) || build_email_validation_from(response.items.first)
    end

    # Verifies the existence of an email address.
    #
    # @param [Hash] options The options to validate an email address.
    # @option options [String] :email The email address to verify.
    # @option options [Integer] :timeout The time (in milliseconds) you want to give for the validation attempt to be
    #   executed within. Value must be between 1 and 15000 (values outside of these ranges will fallback to the
    #   default of 15000).
    #
    # @example
    #   email_validation = email_gateway.validate!(email: 'spam@example.com')
    #
    # @raise [Error] If the result is not a success
    #
    # @return [EmailValidation> An email address validation
    #
    def validate!(options)
      unwrap_result_or_raise { validate(options) }
    end

    # Verifies up to 100 emails per batch.
    #
    # @param [Hash] options The options to validate an email address.
    # @option options [Array<String>] :emails The email addresses to verify. Maximum 100 records.
    #
    # @example
    #   result = email_gateway.batch_validate(emails: %w[spam@example.com example@example.com])
    #   result.value # => [#<Loqate::BatchEmailValidation status="Invalid" ...]
    #
    # @return [Result] A result wrapping a list of email address validations
    #
    def batch_validate(options)
      options[:emails] = options[:emails].join(',') if options[:emails]
      response = client.get(BATCH_VALIDATE_ENDPOINT, options)

      response.errors? && build_error_from(response.items.first) || build_email_validations_from(response.items)
    end

    # Verifies up to 100 emails per batch.
    #
    # @param [Hash] options The options to validate an email address.
    # @option options [Array<String>] :emails The email addresses to verify. Maximum 100 records.
    #
    # @example
    #   email_validations = email_gateway.batch_validate!(emails: %w[spam@example.com example@example.com])
    #
    # @raise [Error] If the result is not a success
    #
    # @return [Array<BatchEmailValidation>] A list of email address validations
    #
    def batch_validate!(options)
      unwrap_result_or_raise { batch_validate(options) }
    end

    private

    # @api private
    attr_reader :client, :mapper, :error_mapper

    # @api private
    def build_error_from(item)
      error = error_mapper.map_one(item)
      Failure(error)
    end

    # @api private
    def build_email_validation_from(item)
      email_validation = mapper.map_one(item, EmailValidation)
      Success(email_validation)
    end

    # @api private
    def build_email_validations_from(item)
      email_validation = mapper.map(item, BatchEmailValidation)
      Success(email_validation)
    end
  end
end
