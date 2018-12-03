require 'loqate/client'
require 'loqate/result'
require 'loqate/mappers/error_mapper'
require 'loqate/mappers/generic_mapper'
require 'loqate/bank/account_validation'
require 'loqate/bank/batch_account_validation'
require 'loqate/bank/card_validation'
require 'loqate/bank/branch'
require 'loqate/bank/international_account_validation'
require 'loqate/bank/card_validation'

module Loqate
  module Bank
    # Validates bank accounts, branches and cards.
    #
    class Gateway
      RETRIEVE_BY_SORTCODE_ENDPOINT = '/BankAccountValidation/Interactive/RetrieveBySortcode/v1.00/json3.ws'.freeze
      VALIDATE_CARD_ENDPOINT        = '/CardValidation/Interactive/Validate/v1/json3.ws'.freeze
      VALIDATE_ACCOUNT_ENDPOINT     = '/BankAccountValidation/Interactive/Validate/v2/json3.ws'.freeze
      VALIDATE_ACCOUNTS_ENDPOINT    = '/BankAccountValidation/Batch/Validate/v1/json3.ws'.freeze
      VALIDATE_INT_ACCOUNT_ENDPOINT = '/InternationalBankValidation/Interactive/Validate/v1/json3.ws'.freeze

      include Result::Mixin

      # Creates a bank gateway
      #
      # @param [Client] client The client responsible for the HTTP interactions
      #
      def initialize(client)
        @client       = client
        @mapper       = Mappers::GenericMapper.new
        @error_mapper = Mappers::ErrorMapper.new
      end

      # Batch validates the bank account and sort code for an UK bank account are correct.
      # Returns details of the holding branch, IBAN and correct BACS account details.
      #
      # @param [Hash] options The options to batch validate bank accounts.
      # @option options [String] :account_numbers The bank account numbers to validate.
      # @option options [String] :sort_codes The branch sort codes for the account number.
      #
      # @example
      #   account_numbers = [123456789, 987654321]
      #   sort_codes = ['12-34-56', '65-43-21']
      #
      #   result = bank_gateway.batch_validate_accounts(
      #     account_numbers: account_numbers,
      #     sort_codes: sort_codes
      #   )
      #
      # @return [Result] A result wrapping multiple account validations
      #
      def batch_validate_accounts(options)
        response = client.get(VALIDATE_ACCOUNTS_ENDPOINT, options)

        response.errors? && build_error_from(response.items.first) || build_account_validations_from(response.items)
      end

      # Validates the bank account and sort code for an UK bank account are correct. Returns details of
      # the holding branch, IBAN and correct BACS account details.
      #
      # @param [Hash] options The options to validate a bank account.
      # @option options [String] :account_number The bank account number to validate.
      # @option options [String] :sort_code The branch sort code for the account number.
      #
      # @example
      #   result = bank_gateway.validate_account(account_number: '123456', sort_code: '12-34-56')
      #
      # @return [Result] A result wrapping a bank account validation
      #
      def validate_account(options)
        response = client.get(VALIDATE_ACCOUNT_ENDPOINT, options)

        first_result = response.items.first
        response.errors? && build_error_from(first_result) || build_account_validation_from(first_result)
      end

      # Validates if the international bank account number for an international bank account is correct.
      #
      # @param [Hash] options The options to validate an international bank account.
      # @option options [String] :iban The international bank account number to validate.
      #
      # @example
      #   result = bank_gateway.validate_international_account(iban: 'GB67HBUK40413151065718')
      #
      # @return [Result] A result wrapping a bank account validation
      #
      def validate_international_account(options)
        response = client.get(VALIDATE_INT_ACCOUNT_ENDPOINT, options)

        first_result = response.items.first
        response.errors? && build_error_from(first_result) || build_int_acc_validation_from(first_result)
      end

      # Returns details of the holding branch.
      #
      # @param [Hash] options The options to retrieve the details of the holding branch.
      # @option options [String] :sort_code The branch sortcode.
      #
      # @example
      #   result = bank_gateway.retrieve_by_postcode(sort_code: 'S1 2HD')
      #
      # @return [Result] A result wrapping a bank branch
      #
      def retrieve_by_sortcode(options)
        response = client.get(RETRIEVE_BY_SORTCODE_ENDPOINT, options)

        response.errors? && build_error_from(response.items.first) || build_branch_from(response.items)
      end

      # Validates the credit card number follows the correct format for the card type.
      #
      # @param [Hash] options The options to validate an card.
      # @option options [String] :card_number The full card number. Any spaces or non numeric
      #   characters will be ignored.
      #
      # @example
      #   result = bank_gateway.validate_card(card_number: '4024 0071 7123 9865')
      #
      # @return [Result] A result wrapping a card validation
      #
      def validate_card(options)
        response = client.get(VALIDATE_CARD_ENDPOINT, options)

        response.errors? && build_error_from(response.items.first) || build_card_validation_from(response.items.first)
      end

      # Batch validates the bank account and sort code for an UK bank account are correct.
      # Returns details of the holding branch, IBAN and correct BACS account details.
      #
      # @param [Hash] options The options to batch validate bank accounts.
      # @option options [String] :account_numbers The bank account numbers to validate.
      # @option options [String] :sort_codes The branch sort codes for the account number.
      #
      # @example
      #   account_numbers = [123456789, 987654321]
      #   sort_codes = ['12-34-56', '65-43-21']
      #
      #   account_validations = bank_gateway.batch_validate_accounts!(
      #     account_numbers: account_numbers,
      #     sort_codes: sort_codes
      #   )
      #
      # @raise [Error] If the result is not a success
      #
      # @return [Array<BatchAccountValidation>] A list of account validations
      #
      def batch_validate_accounts!(options)
        unwrap_result_or_raise { batch_validate_accounts(options) }
      end

      # Validates the bank account and sort code for an UK bank account are correct. Returns details of
      # the holding branch, IBAN and correct BACS account details.
      #
      # @param [Hash] options The options to validate a bank account.
      # @option options [String] :account_number The bank account number to validate.
      # @option options [String] :sort_code The branch sort code for the account number.
      #
      # @example
      #   bank_validation = bank_gateway.validate_account!(account_number: '123456', sort_code: '12-34-56')
      #
      # @raise [Error] If the result is not a success
      #
      # @return [AccountValidation] A bank account validation
      #
      def validate_account!(options)
        unwrap_result_or_raise { validate_account(options) }
      end

      # Validates if the international bank account number for an international bank account is correct.
      #
      # @param [Hash] options The options to validate an international bank account.
      # @option options [String] :iban The international bank account number to validate.
      #
      # @example
      #   bank_validation = bank_gateway.validate_international_account!(iban: 'GB67HBUK40413151065718')
      #
      # @raise [Error] If the result is not a success
      #
      # @return [InternationalAccountValidation] An international bank account validation
      #
      def validate_international_account!(options)
        unwrap_result_or_raise { validate_international_account(options) }
      end

      # Returns details of the holding branch.
      #
      # @param [Hash] options The options to retrieve the details of the holding branch.
      # @option options [String] :sort_code The branch sortcode.
      #
      # @example
      #   branch = bank_gateway.retrieve_by_postcode!(sort_code: 'S1 2HD')
      #
      # @raise [Error] If the result is not a success
      #
      # @return [Branch] A bank branch
      #
      def retrieve_by_sortcode!(options)
        unwrap_result_or_raise { retrieve_by_sortcode(options) }
      end

      # Validates the credit card number follows the correct format for the card type.
      #
      # @param [Hash] options The options to validate an card.
      # @option options [String] :card_number The full card number. Any spaces or non numeric
      #   characters will be ignored.
      #
      # @example
      #   card_validation = bank_gateway.validate_card!(card_number: '4024 0071 7123 9865')
      #
      # @raise [Error] If the result is not a success
      #
      # @return [CardValidation] A card validation
      #
      def validate_card!(options)
        unwrap_result_or_raise { validate_card(options) }
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
      def build_account_validation_from(item)
        account_validation = mapper.map_one(item, AccountValidation)
        Success(account_validation)
      end

      # @api private
      def build_account_validations_from(items)
        batch_account_validation = mapper.map(items, BatchAccountValidation)
        Success(batch_account_validation)
      end

      # @api private
      def build_int_acc_validation_from(item)
        account_validation = mapper.map_one(item, InternationalAccountValidation)
        Success(account_validation)
      end

      # @api private
      def build_card_validation_from(item)
        card_validation = mapper.map_one(item, CardValidation)
        Success(card_validation)
      end

      # @api private
      def build_branch_from(items)
        bank_branch = mapper.map(items, Branch).first
        Success(bank_branch)
      end
    end
  end
end
