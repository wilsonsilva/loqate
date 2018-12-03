require 'loqate/address/detailed_address'

RSpec.describe Loqate::Address::DetailedAddress do
  let(:address) { described_class.new(id: 1) }

  described_class::ATTRIBUTES.each do |attribute|
    describe "##{attribute}" do
      it "exposes #{attribute}" do
        expect(address).to respond_to(attribute)
      end
    end
  end

  describe '#==' do
    context 'when the addresses have the same id' do
      let(:address2) do
        described_class.new(id: 1)
      end

      it 'returns true' do
        expect(address).to eq(address2)
      end
    end

    context 'when the addresses do not have the same id' do
      let(:address2) do
        described_class.new(id: 2)
      end

      it 'returns false' do
        expect(address).not_to eq(address2)
      end
    end

    context 'when comparing with another class' do
      let(:address2) { double(id: 1) }

      it 'returns true' do
        expect(address).not_to eq(address2)
      end
    end
  end
end
