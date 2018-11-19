module Loqate
  # Result of a batch email address validation.
  class BatchEmailValidation < Dry::Struct::Value
    Status = Types::Strict::String.enum('Valid', 'Invalid', 'Unknown', 'Accept_All')

    # Valid - The email address is valid
    # Invalid - The email address is invalid and shouldn't be accepted
    # Unknown - Unable to complete the verification process (normally due to SMTP timeout)
    # Accept_All - The mail server is set to accept all verification requests so full verification isn't possible
    #
    # @return ['Valid', 'Invalid', 'Unknown', 'Accept_All']
    #
    attribute :status, Status

    # The email address that verification was attempted on.
    #
    # @return [String]
    #
    attribute :email_address, Types::Strict::String

    # The account portion of the email address provided.
    #
    # @return [String
    #
    attribute :account, Types::Strict::String

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
    attribute :is_disposible, Types::Strict::Bool

    # Whether the email address provided is a system mailbox (e.g. sales@, support@, accounts@ etc).
    #
    # @return [Boolean]
    #
    attribute :is_system_mailbox, Types::Strict::Bool

    # Whether the email was fully validated (including the account portion).
    def valid?
      status == 'Valid'
    end

    # Whether the email is invalid and shouldn't be accepted.
    def invalid?
      status == 'Invalid'
    end

    # Whether the email wasn't verified (normally due to SMTP timeout)
    def unknown?
      status == 'Unknown'
    end

    # Whether the email could be verified
    def unverified?
      status == 'Accept_All'
    end
  end
end
