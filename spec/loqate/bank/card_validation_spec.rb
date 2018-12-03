require 'loqate/bank/card_validation'

RSpec.describe Loqate::Bank::CardValidation do
  let(:attributes) do
    {
      card_number: '1234567891011',
      card_type: 'Visa'
    }
  end
  let(:branch) { described_class.new(attributes) }

  describe '#card_number' do
    it 'exposes the cleaned card number' do
      expect(branch.card_number).to eq('1234567891011')
    end
  end

  describe '#card_type' do
    it 'exposes the card type (e.g. Visa, Mastercard etc)' do
      expect(branch.card_type).to eq('Visa')
    end
  end
end
