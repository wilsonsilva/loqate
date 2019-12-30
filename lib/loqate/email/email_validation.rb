module Loqate
  module Email
    # Result of a email address validation.
    class EmailValidation < Dry::Struct
      ResponseCode = Types::Strict::String.enum('Valid', 'Valid_CatchAll', 'Invalid', 'Timeout')

      # Valid - The email address has been fully validated (including the account portion)
      # Valid_CatchAll - The domain has been validated but the account could not be validated
      # Invalid - The email address is invalid and shouldn't be accepted
      # Timeout - The validation could not be completed within the timeout specified (try increasing the timeout value)
      #
      # @return ['Valid', 'Valid_CatchAll', 'Invalid', 'Timeout']
      #
      attribute :response_code, ResponseCode

      # A textual description of the ResponseCode returned
      #
      # @return [String]
      #
      attribute :response_message, Types::Strict::String

      # The email address that verification was attempted on.
      #
      # @return [String]
      #
      attribute :email_address, Types::Strict::String

      # The account portion of the email address provided.
      #
      # @return [String
      #
      attribute :user_account, Types::Strict::String

      # The domain portion of the email address provided.
      #
      # @return [String]
      #
      attribute :domain, Types::Strict::String

      # Whether the email address provided is a disposable mailbox (some companies create temporary mailboxes
      # which shouldn't be used for marketing communications).
      #
      # @return [Boolean]
      #
      attribute :is_disposable_or_temporary, Types::Strict::Bool

      # True if we recognise the email address against known lists of complainers and/or the email address has been
      # used to defraud.
      #
      # @return [Boolean]
      #
      attribute :is_complainer_or_fraud_risk, Types::Strict::Bool

      # The duration (in seconds) that the email validation took (maximum timeout enforced at 15 seconds).
      # We recommend a high timeout (at least 5 seconds) value as it will minimise the number of "Timeout"
      # responses returned.
      #
      # @return [Float]
      #
      attribute :duration, Types::Strict::Float

      # Whether the email was fully validated (including the account portion).
      def valid?
        response_code == 'Valid'
      end

      # Whether the domain has been validated but the account hasn't.
      def valid_domain?
        response_code == 'Valid' || response_code == 'Valid_CatchAll'
      end

      # Whether the email is invalid and shouldn't be accepted.
      def invalid?
        response_code == 'Invalid'
      end

      # Whether the validation could not be completed within the timeout specified.
      def timeout?
        response_code == 'Timeout'
      end
    end
  end
end
