module Loqate
  module Bank
    # Result of a bank branch retrieval.
    class Branch < Dry::Struct::Value
      # The name of the banking institution.
      #
      # @return [String]
      #
      attribute :bank, Types::Strict::String

      # The banking institution's BIC, also know as the SWIFT BIC.
      #
      # @return [String]
      #
      attribute :bank_bic, Types::Strict::String

      # The name of the account holding branch.
      #
      # @return [String]
      #
      attribute :branch, Types::Strict::String

      # The branch's BIC.
      #
      # @return [String]
      #
      attribute :branch_bic, Types::Strict::String

      # Line 1 of the branch's contact address. NB: This is the address to be used for BACs enquiries and may
      # be a contact centre rather than the branch's address.
      #
      # @return [String]
      #
      attribute :contact_address_line1, Types::Strict::String

      # Line 2 of the branch's contact address.
      #
      # @return [String]
      #
      attribute :contact_address_line2, Types::Strict::String

      # The branch's contact post town.
      #
      # @return [String]
      #
      attribute :contact_post_town, Types::Strict::String

      # The branch's contact postcode.
      #
      # @return [String]
      #
      attribute :contact_postcode, Types::Strict::String

      # The branch's contact phone number.
      #
      # @return [String]
      #
      attribute :contact_phone, Types::Strict::String

      # The branch's contact fax number.
      #
      # @return [String]
      #
      attribute :contact_fax, Types::Strict::String

      # Indicates that the account supports the faster payments service.
      #
      # @return [Boolean]
      #
      attribute :faster_payments_supported, Types::Strict::Bool

      # Indicates that the account supports the CHAPS service.
      #
      # @return [Boolean]
      #
      attribute :chaps_supported, Types::Strict::Bool
    end
  end
end
