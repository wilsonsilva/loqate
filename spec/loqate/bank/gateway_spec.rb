require 'loqate/bank/gateway'

RSpec.describe Loqate::Bank::Gateway, vcr: true do
  let(:dev_api_key)   { File.read("#{File.dirname(__FILE__)}/../../../.api_key").strip }
  let(:configuration) { Loqate::Configuration.new(api_key: dev_api_key) }
  let(:client)        { Loqate::Client.new(configuration) }
  let(:bank_gateway)  { described_class.new(client) }

  describe '#batch_validate_accounts' do
    context 'when invoked without account numbers' do
      let(:error) do
        Loqate::Error.new(
          cause: 'At least 1 AccountNumber parameter is required.',
          description: 'AccountNumbers Required',
          id: 1002,
          resolution: 'Please ensure that you supply at least 1 AccountNumber parameter and try again.'
        )
      end

      it 'returns an error' do
        result = bank_gateway.batch_validate_accounts(sort_codes: %w[40-41-31 083210])
        expect(result.value).to eq(error)
      end
    end

    context 'when invoked without sort codes' do
      let(:error) do
        Loqate::Error.new(
          cause: 'At least 1 SortCode parameter is required.',
          description: 'SortCodes Required',
          id: 1001,
          resolution: 'Please ensure that you supply at least 1 SortCode parameter and try again.'
        )
      end

      it 'returns an error' do
        result = bank_gateway.batch_validate_accounts(account_numbers: %w[51065718 12001020])
        expect(result.value).to eq(error)
      end
    end

    context 'when there is a mismatch between account numbers and sort codes' do
      let(:error) do
        Loqate::Error.new(
          cause: 'The AccountNumber parameter was not valid.',
          description: 'Inconsistent Sortcodes and AccountNumbers',
          id: 1003,
          resolution: 'The AccountNumber parameter should contain only numbers. Account numbers \
            must be between 6-10 digits long.'
        )
      end

      it 'returns an error' do
        result = bank_gateway.batch_validate_accounts(
          account_numbers: %w[51065718 12001020],
          sort_codes: ['40-41-31']
        )
        expect(result.value).to eq(error)
      end
    end

    context 'when invoked with the correct account numbers and sort codes' do
      it 'validates multiple accounts' do
        result = bank_gateway.batch_validate_accounts(
          account_numbers: %w[51065718 12001020],
          sort_codes: %w[40-41-31 083210]
        )

        aggregate_failures do
          expect(result.value.first).to eq(
            Loqate::Bank::BatchAccountValidation.new(
              bank: 'HSBC UK BANK PLC',
              bank_bic: 'HBUKGB41',
              branch: 'Sheffield City',
              branch_bic: '54D',
              contact_address_line1: 'Carmel House',
              contact_address_line2: '49-63 Fargate',
              contact_fax: '',
              contact_phone: '',
              contact_post_town: 'Sheffield',
              contact_postcode: 'S1 2HD',
              corrected_account_number: '51065718',
              corrected_sort_code: '404131',
              iban: 'GB67HBUK40413151065718',
              is_correct: true,
              is_direct_debit_capable: true,
              original_account_number: '51065718',
              original_sort_code: '404131',
              status_information: 'OK'
            )
          )

          expect(result.value.last).to eq(
            Loqate::Bank::BatchAccountValidation.new(
              bank: 'GOVERNMENT BANKING',
              bank_bic: '',
              branch: 'Hmrc Direct Taxes',
              branch_bic: '',
              contact_address_line1: '',
              contact_address_line2: '',
              contact_fax: '',
              contact_phone: '',
              contact_post_town: '',
              contact_postcode: '',
              corrected_account_number: '12001020',
              corrected_sort_code: '083210',
              iban: '',
              is_correct: true,
              is_direct_debit_capable: false,
              original_account_number: '12001020',
              original_sort_code: '083210',
              status_information: 'CautiousOK'
            )
          )
        end
      end
    end
  end

  describe '#batch_validate_accounts!' do
    context 'when the result is successful' do
      it 'returns the unwrapped result' do
        result = bank_gateway.batch_validate_accounts!(account_numbers: %w[51065718], sort_codes: %w[40-41-31])

        expect(result.first).to eq(
          Loqate::Bank::BatchAccountValidation.new(
            bank: 'HSBC UK BANK PLC',
            bank_bic: 'HBUKGB41',
            branch: 'Sheffield City',
            branch_bic: '54D',
            contact_address_line1: 'Carmel House',
            contact_address_line2: '49-63 Fargate',
            contact_fax: '',
            contact_phone: '',
            contact_post_town: 'Sheffield',
            contact_postcode: 'S1 2HD',
            corrected_account_number: '51065718',
            corrected_sort_code: '404131',
            iban: 'GB67HBUK40413151065718',
            is_correct: true,
            is_direct_debit_capable: true,
            original_account_number: '51065718',
            original_sort_code: '404131',
            status_information: 'OK'
          )
        )
      end
    end

    context 'when the result is not successful' do
      it 'raises an error' do
        expect do
          bank_gateway.batch_validate_accounts!({})
        end.to raise_error(Loqate::Error, 'AccountNumbers Required')
      end
    end
  end

  describe '#validate_account' do
    context 'when invoked without a sort code' do
      let(:error) do
        Loqate::Error.new(
          cause: 'The SortCode parameter was not supplied.',
          description: 'SortCode Required',
          id: 1001,
          resolution: 'Please ensure that you supply the SortCode parameter and try again.'
        )
      end

      it 'returns an error' do
        result = bank_gateway.validate_account(account_number: '51065718')
        expect(result.value).to eq(error)
      end
    end

    context 'when invoked without an account number' do
      let(:error) do
        Loqate::Error.new(
          cause: 'The AccountNumber parameter was not supplied.',
          description: 'AccountNumber Required',
          id: 1003,
          resolution: 'Please ensure that you supply the AccountNumber parameter and try again.'
        )
      end

      it 'returns an error' do
        result = bank_gateway.validate_account(sort_code: '404131')
        expect(result.value).to eq(error)
      end
    end

    context 'when the account exists' do
      it 'returns an account validation' do
        result = bank_gateway.validate_account(account_number: '51065718', sort_code: '404131')

        expect(result.value).to eq(
          Loqate::Bank::AccountValidation.new(
            is_correct: true,
            is_direct_debit_capable: true,
            status_information: 'OK',
            corrected_sort_code: '404131',
            corrected_account_number: '51065718',
            iban: 'GB67HBUK40413151065718',
            bank: 'HSBC UK BANK PLC',
            bank_bic: 'HBUKGB41',
            branch: 'Sheffield City',
            branch_bic: '54D',
            contact_address_line1: 'Carmel House',
            contact_address_line2: '49-63 Fargate',
            contact_post_town: 'Sheffield',
            contact_postcode: 'S1 2HD',
            contact_phone: '',
            contact_fax: '',
            faster_payments_supported: true,
            chaps_supported: true
          )
        )
      end
    end

    context 'when the account does not exist' do
      it 'returns an empty account validation' do
        result = bank_gateway.validate_account(account_number: '00000000', sort_code: '000000')

        expect(result.value).to eq(
          Loqate::Bank::AccountValidation.new(
            is_correct: false,
            is_direct_debit_capable: false,
            status_information: 'UnknownSortCode',
            corrected_sort_code: '',
            corrected_account_number: '',
            iban: '',
            bank: '',
            bank_bic: '',
            branch_bic: '',
            branch: '',
            contact_address_line1: '',
            contact_address_line2: '',
            contact_post_town: '',
            contact_postcode: '',
            contact_phone: '',
            contact_fax: '',
            faster_payments_supported: false,
            chaps_supported: false
          )
        )
      end
    end
  end

  describe '#validate_account!' do
    context 'when the result is successful' do
      it 'returns the unwrapped result' do
        result = bank_gateway.validate_account!(account_number: '51065718', sort_code: '404131')

        expect(result).to eq(
          Loqate::Bank::AccountValidation.new(
            is_correct: true,
            is_direct_debit_capable: true,
            status_information: 'OK',
            corrected_sort_code: '404131',
            corrected_account_number: '51065718',
            iban: 'GB67HBUK40413151065718',
            bank: 'HSBC UK BANK PLC',
            bank_bic: 'HBUKGB41',
            branch: 'Sheffield City',
            branch_bic: '54D',
            contact_address_line1: 'Carmel House',
            contact_address_line2: '49-63 Fargate',
            contact_post_town: 'Sheffield',
            contact_postcode: 'S1 2HD',
            contact_phone: '',
            contact_fax: '',
            faster_payments_supported: true,
            chaps_supported: true
          )
        )
      end
    end

    context 'when the result is not successful' do
      it 'raises an error' do
        expect do
          bank_gateway.validate_account!({})
        end.to raise_error(Loqate::Error, 'AccountNumber Required')
      end
    end
  end

  describe '#validate_card' do
    context 'when invoked without a card number' do
      let(:error) do
        Loqate::Error.new(
          cause: 'The CardNumber parameter was not supplied.',
          description: 'CardNumber Required',
          id: 1001,
          resolution: 'Please ensure that you supply the CardNumber parameter and try again.'
        )
      end

      it 'returns an error' do
        result = bank_gateway.validate_card({})
        expect(result.value).to eq(error)
      end
    end

    context 'when invoked with an invalid card number' do
      it 'returns a card validation' do
        result = bank_gateway.validate_card(card_number: '404')

        expect(result.value).to eq(
          Loqate::Bank::CardValidation.new(
            card_number: '404',
            card_type: ''
          )
        )
      end
    end

    context 'when invoked with a valid card number' do
      it 'returns a card validation' do
        result = bank_gateway.validate_card(card_number: '4024007171239865')

        expect(result.value).to eq(
          Loqate::Bank::CardValidation.new(
            card_number: '4024007171239865',
            card_type: 'VISA'
          )
        )
      end
    end
  end

  describe '#validate_card!' do
    context 'when the result is successful' do
      it 'returns the unwrapped result' do
        result = bank_gateway.validate_card!(card_number: '4024007171239865')
        expect(result).to eq(
          Loqate::Bank::CardValidation.new(
            card_number: '4024007171239865',
            card_type: 'VISA'
          )
        )
      end
    end

    context 'when the result is not successful' do
      it 'raises an error' do
        expect do
          bank_gateway.validate_card!({})
        end.to raise_error(Loqate::Error, 'CardNumber Required')
      end
    end
  end

  describe '#validate_international_account' do
    context 'when invoked without an IBAN' do
      let(:error) do
        Loqate::Error.new(
          cause: 'The IBAN parameter was not supplied.',
          description: 'IBAN Required',
          id: 1001,
          resolution: 'Please ensure that you supply the IBAN parameter and try again.'
        )
      end

      it 'returns an error' do
        result = bank_gateway.validate_international_account({})
        expect(result.value).to eq(error)
      end
    end

    context 'when invoked with an invalid IBAN' do
      let(:error) do
        Loqate::Error.new(
          cause: 'The IBAN parameter was not valid.',
          description: 'IBAN Invalid',
          id: 1002,
          resolution: 'The IBAN parameter should contain only numbers and letters and have a \
            length of at least fifteen characters.'
        )
      end

      it 'returns an error' do
        result = bank_gateway.validate_international_account(iban: 'wong')
        expect(result.value).to eq(error)
      end
    end

    context 'when an account exists with the given IBAN' do
      it 'returns an international account validation' do
        result = bank_gateway.validate_international_account(iban: 'GB03 BARC 201147 8397 7692')
        expect(result.value).to eq(Loqate::Bank::InternationalAccountValidation.new(is_correct: true))
      end
    end

    context 'when an account does not exist with the given IBAN' do
      it 'returns an international account validation' do
        result = bank_gateway.validate_international_account(iban: 'GB99 ANOC 000000 0000 0000')
        expect(result.value).to eq(Loqate::Bank::InternationalAccountValidation.new(is_correct: false))
      end
    end
  end

  describe '#validate_international_account!' do
    context 'when the result is successful' do
      it 'returns the unwrapped result' do
        result = bank_gateway.validate_international_account!(iban: 'GB03 BARC 201147 8397 7692')
        expect(result).to eq(Loqate::Bank::InternationalAccountValidation.new(is_correct: true))
      end
    end

    context 'when the result is not successful' do
      it 'raises an error' do
        expect do
          bank_gateway.validate_international_account!({})
        end.to raise_error(Loqate::Error, 'IBAN Required')
      end
    end
  end

  describe '#retrieve_by_sortcode' do
    context 'when invoked without a sort code' do
      let(:error) do
        Loqate::Error.new(
          cause: 'The SortCode parameter was not supplied.',
          description: 'SortCode Required',
          id: 1001,
          resolution: 'Please ensure that you supply the SortCode parameter and try again.'
        )
      end

      it 'returns an error' do
        result = bank_gateway.retrieve_by_sortcode({})
        expect(result.value).to eq(error)
      end
    end

    context 'when the branch is not found' do
      it 'returns nil' do
        result = bank_gateway.retrieve_by_sortcode(sort_code: '000000')
        expect(result.value).to be_nil
      end
    end

    context 'when the branch is found' do
      it 'returns the branch' do
        result = bank_gateway.retrieve_by_sortcode(sort_code: '404131')

        expect(result.value).to eq(
          Loqate::Bank::Branch.new(
            bank: 'HSBC UK BANK PLC',
            bank_bic: 'HBUKGB41',
            branch: 'Sheffield City',
            branch_bic: '54D',
            contact_address_line1: 'Carmel House',
            contact_address_line2: '49-63 Fargate',
            contact_fax: '',
            contact_phone: '',
            contact_post_town: 'Sheffield',
            contact_postcode: 'S1 2HD',
            chaps_supported: true,
            faster_payments_supported: true
          )
        )
      end
    end
  end

  describe '#retrieve_by_sortcode!' do
    context 'when the result is successful' do
      it 'returns the unwrapped result' do
        branch = bank_gateway.retrieve_by_sortcode!(sort_code: '404131')

        expect(branch).to eq(
          Loqate::Bank::Branch.new(
            bank: 'HSBC UK BANK PLC',
            bank_bic: 'HBUKGB41',
            branch: 'Sheffield City',
            branch_bic: '54D',
            contact_address_line1: 'Carmel House',
            contact_address_line2: '49-63 Fargate',
            contact_fax: '',
            contact_phone: '',
            contact_post_town: 'Sheffield',
            contact_postcode: 'S1 2HD',
            chaps_supported: true,
            faster_payments_supported: true
          )
        )
      end
    end

    context 'when the result is not successful' do
      it 'raises an error' do
        expect do
          bank_gateway.retrieve_by_sortcode!({})
        end.to raise_error(Loqate::Error, 'SortCode Required')
      end
    end
  end
end
