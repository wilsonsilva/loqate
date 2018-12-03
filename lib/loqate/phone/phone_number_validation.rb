module Loqate
  module Phone
    # Result of a phone number validation.
    class PhoneNumberValidation < Dry::Struct::Value
      IsValid = Types::Strict::String.enum('Yes', 'No', 'Unknown')
      NumberType = Types::Strict::String.enum('Mobile', 'Landline', 'Voip', 'Unknown')

      # The recipient phone number in international format.
      #
      # @return [String]
      #
      attribute :phone_number, Types::Strict::String

      # Returns true if we managed to process the request on the network or false if the validation
      # attempt was unsuccessful.
      #
      # @return [Boolean]
      #
      attribute :request_processed, Types::Strict::Bool

      # Whether the number is valid or not (Unknown returned if validation wasn't possible).
      #
      # @return [String]
      #
      attribute :is_valid, IsValid

      # The current operator serving the supplied number.
      #
      # @return [String]
      #
      attribute :network_code, Types::Strict::String

      # The name of the current operator serving the supplied number.
      #
      # @return [String]
      #
      attribute :network_name, Types::Strict::String

      # The country code of the operator.
      #
      # @return [String]
      #
      attribute :network_country, Types::Strict::String

      # The domestic network format (useful for dialling from within the same country).
      #
      # @return [String]
      #
      attribute :national_format, Types::Strict::String

      # The country prefix that must be prepended to the number when dialling internationally.
      #
      # @return [Integer]
      #
      attribute :country_prefix, Types::Coercible::Integer

      # The type of number that was detected in the request (Mobile, Landline, VOIP or Unknown).
      #
      # @return [String]
      #
      attribute :number_type, NumberType

      # Whether the validation was successful or not.
      def valid?
        is_valid == 'Yes'
      end
    end
  end
end
