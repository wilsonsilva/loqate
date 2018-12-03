require 'loqate/client'
require 'loqate/result'
require 'loqate/mappers/error_mapper'
require 'loqate/mappers/generic_mapper'
require 'loqate/phone/phone_number_validation'

module Loqate
  module Phone
    # Starts a new phone number validation request.
    #
    class Gateway
      VALIDATE_ENDPOINT = '/PhoneNumberValidation/Interactive/Validate/v2.20/json3.ws'.freeze

      include Result::Mixin

      # Creates a phone gateway
      #
      # @param [Client] client The client responsible for the HTTP interactions
      #
      def initialize(client)
        @client       = client
        @mapper       = Mappers::GenericMapper.new
        @error_mapper = Mappers::ErrorMapper.new
      end

      # Validates phone numbers.
      #
      # @param [Hash] options The options to validate a phone number.
      # @option options [String] :phone The mobile/cell phone number to verify. This must be in international format
      #   (+447528471411 or 447528471411) if no country code is provided or national format with a Country parameter
      #   provided (07528471411 and GB as the Country parameter).
      # @option options [String] :country The ISO2 country code of the number you are trying to validate
      #   (if provided in national format).
      #
      # @example
      #   phone_validation = phone_gateway.validate(phone: '447440019210', country: 'GB')
      #
      # @return [Result] A result wrapping a phone number validation
      #
      def validate(options)
        response = client.get(VALIDATE_ENDPOINT, options)

        response.errors? && build_error_from(response.items.first) || build_phone_validation_from(response.items.first)
      end

      # Validates phone numbers.
      #
      # @param [Hash] options The options to validate a phone number.
      # @option options [String] :phone The mobile/cell phone number to verify. This must be in international format
      #   (+447528471411 or 447528471411) if no country code is provided or national format with a Country parameter
      #   provided (07528471411 and GB as the Country parameter).
      # @option options [String] :country The ISO2 country code of the number you are trying to validate
      #   (if provided in national format).
      #
      # @example
      #   phone_validation = phone_gateway.validate(phone: '447440019210', country: 'GB')
      #
      # @raise [Error] If the result is not a success
      #
      # @return [PhoneNumberValidation> A phone number validation
      #
      def validate!(options)
        unwrap_result_or_raise { validate(options) }
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
      def build_phone_validation_from(item)
        phone_number_validation = mapper.map_one(item, PhoneNumberValidation)
        Success(phone_number_validation)
      end
    end
  end
end
