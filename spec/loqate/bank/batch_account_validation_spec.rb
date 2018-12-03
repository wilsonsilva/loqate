require 'loqate/bank/batch_account_validation'

RSpec.describe Loqate::Bank::BatchAccountValidation do
  let(:attributes) do
    {
      bank: 'HSBC UK BANK PLC',
      bank_bic: 'HBUKGB41',
      branch: 'Sheffield City',
      branch_bic: '54D',
      contact_address_line1: 'Carmel House',
      contact_address_line2: '49-63 Fargate',
      contact_fax: '+44-208-1234567',
      contact_phone: '0345 740 4404',
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
    }
  end
  let(:account_validation) { described_class.new(attributes) }

  describe '#original_account_number' do
    it 'exposes the original account number passed to validate, excluding any non numeric characters' do
      expect(account_validation.original_account_number).to eq('51065718')
    end
  end

  describe '#original_sort_code' do
    it 'exposes the original sort code passed to validate, excluding any non numeric characters' do
      expect(account_validation.original_sort_code).to eq('404131')
    end
  end

  describe '#is_correct' do
    it 'exposes whether the account number and sortcode are valid' do
      expect(account_validation.is_correct).to eq(true)
    end
  end

  describe '#is_direct_debit_capable' do
    it 'exposes whether the account can accept direct debits' do
      expect(account_validation.is_direct_debit_capable).to eq(true)
    end
  end

  describe '#status_information' do
    it 'exposes more detail about the outcome of the validation process' do
      expect(account_validation.status_information).to eq('OK')
    end
  end

  describe '#corrected_sort_code' do
    it 'exposes the correct version of the sort code' do
      expect(account_validation.corrected_sort_code).to eq('404131')
    end
  end

  describe '#corrected_account_number' do
    it 'exposes the correct version of the account number' do
      expect(account_validation.corrected_account_number).to eq('51065718')
    end
  end

  describe '#iban' do
    it 'exposes the correctly formatted IBAN for the account' do
      expect(account_validation.iban).to eq('GB67HBUK40413151065718')
    end
  end

  describe '#bank' do
    it 'exposes the name of the banking institution' do
      expect(account_validation.bank).to eq('HSBC UK BANK PLC')
    end
  end

  describe '#bank_bic' do
    it "'exposes the banking institution's BIC, also know as the SWIFT BIC" do
      expect(account_validation.bank_bic).to eq('HBUKGB41')
    end
  end

  describe '#branch' do
    it 'exposes the name of the account holding branch' do
      expect(account_validation.branch).to eq('Sheffield City')
    end
  end

  describe '#branch_bic' do
    it "exposes the branch's BIC" do
      expect(account_validation.branch_bic).to eq('54D')
    end
  end

  describe '#contact_address_line1' do
    it "exposes the line 1 of the branch's contact address" do
      expect(account_validation.contact_address_line1).to eq('Carmel House')
    end
  end

  describe '#contact_address_line2' do
    it "exposes the line 2 of the branch's contact address" do
      expect(account_validation.contact_address_line2).to eq('49-63 Fargate')
    end
  end

  describe '#contact_post_town' do
    it "exposes the branch's contact post town" do
      expect(account_validation.contact_post_town).to eq('Sheffield')
    end
  end

  describe '#contact_postcode' do
    it "exposes the branch's contact postcode" do
      expect(account_validation.contact_postcode).to eq('S1 2HD')
    end
  end

  describe '#contact_phone' do
    it "exposes the branch's contact phone number" do
      expect(account_validation.contact_phone).to eq('0345 740 4404')
    end
  end

  describe '#contact_fax' do
    it "exposes the branch's contact fax number" do
      expect(account_validation.contact_fax).to eq('+44-208-1234567')
    end
  end
end
