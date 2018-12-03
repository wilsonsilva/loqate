module Loqate
  module Bank
    # Result of a batch bank account validation.
    class BatchAccountValidation < Dry::Struct::Value
      StatusInformation = Types::Strict::String.enum('CautiousOK', 'DetailsChanged', 'OK')

      # The original AccountNumber passed to validate, excluding any non numeric characters.
      #
      # @return [String]
      #
      attribute :original_account_number, Types::Strict::String

      # The original SortCode passed to validate, excluding any non numeric characters.
      #
      # @return [String]
      #
      attribute :original_sort_code, Types::Strict::String

      # Indicates whether the account number and sortcode are valid.
      #
      # @return [Boolean]
      #
      attribute :is_correct, Types::Strict::Bool
      alias correct? is_correct

      # Indicates whether the account can accept direct debits. Certain accounts (e.g. savings) will
      # not accept direct debits.
      #
      # @return [Boolean]
      #
      attribute :is_direct_debit_capable, Types::Strict::Bool

      # More detail about the outcome of the validation process. Describes reasons validation failed or changes
      # made to pass validation. DetailsChanged indicates that the account and sortcode should be changed for
      # BACs submission (check CorrectedAccountNumber and CorrectedSortCode). CautiousOK is set where the sortcode
      # exists but no validation rules are set for the bank (very rare).
      #
      # @return [String]
      #
      attribute :status_information, StatusInformation

      # The correct version of the SortCode. This will be 6 digits long with no hyphens. It may differ from
      # the original sortcode.
      #
      # @return [String]
      #
      attribute :corrected_sort_code, Types::Strict::String

      # he correct version of the AccountNumber. This will be 8 digits long and in the form expected
      # for BACs submission.
      #
      # @return [String]
      #
      attribute :corrected_account_number, Types::Strict::String

      # The correctly formatted IBAN for the account.
      #
      # @return [String]
      #
      attribute :iban, Types::Strict::String

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
    end
  end
end
