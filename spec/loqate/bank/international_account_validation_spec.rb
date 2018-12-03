require 'loqate/bank/international_account_validation'

RSpec.describe Loqate::Bank::InternationalAccountValidation do
  let(:attributes) do
    {
      is_correct: true
    }
  end
  let(:account_validation) { described_class.new(attributes) }

  describe '#is_correct' do
    it 'exposes whether the account number and sortcode are valid' do
      expect(account_validation.is_correct).to eq(true)
    end
  end
end
