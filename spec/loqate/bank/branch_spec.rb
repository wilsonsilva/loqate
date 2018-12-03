require 'loqate/bank/branch'

RSpec.describe Loqate::Bank::Branch do
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
      chaps_supported: true,
      faster_payments_supported: true
    }
  end
  let(:branch) { described_class.new(attributes) }

  describe '#bank' do
    it 'exposes the name of the banking institution' do
      expect(branch.bank).to eq('HSBC UK BANK PLC')
    end
  end

  describe '#bank_bic' do
    it "'exposes the banking institution's BIC, also know as the SWIFT BIC" do
      expect(branch.bank_bic).to eq('HBUKGB41')
    end
  end

  describe '#branch' do
    it 'exposes the name of the account holding branch' do
      expect(branch.branch).to eq('Sheffield City')
    end
  end

  describe '#branch_bic' do
    it "exposes the branch's BIC" do
      expect(branch.branch_bic).to eq('54D')
    end
  end

  describe '#contact_address_line1' do
    it "exposes the line 1 of the branch's contact address" do
      expect(branch.contact_address_line1).to eq('Carmel House')
    end
  end

  describe '#contact_address_line2' do
    it "exposes the line 2 of the branch's contact address" do
      expect(branch.contact_address_line2).to eq('49-63 Fargate')
    end
  end

  describe '#contact_fax' do
    it "exposes the branch's contact fax number" do
      expect(branch.contact_fax).to eq('+44-208-1234567')
    end
  end

  describe '#contact_phone' do
    it "exposes the branch's contact phone number" do
      expect(branch.contact_phone).to eq('0345 740 4404')
    end
  end

  describe '#contact_post_town' do
    it "exposes the branch's contact post town" do
      expect(branch.contact_post_town).to eq('Sheffield')
    end
  end

  describe '#contact_postcode' do
    it "exposes the branch's contact postcode" do
      expect(branch.contact_postcode).to eq('S1 2HD')
    end
  end

  describe '#chaps_supported' do
    it 'exposes whether the account number and sortcode are valid' do
      expect(branch.chaps_supported).to eq(true)
    end
  end

  describe '#faster_payments_supported' do
    it 'exposes wether the account supports the CHAPS service' do
      expect(branch.faster_payments_supported).to eq(true)
    end
  end
end
