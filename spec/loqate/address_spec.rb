require 'loqate/address'

RSpec.describe Loqate::Address do
  let(:attributes) do
    {
      id: 'GB|RM|ENG|LONDON---LANE-SCRUBS',
      type: 'Street',
      text: 'Scrubs Lane',
      highlight: '0-6,7-11',
      description: 'London - 208 Addresses'
    }
  end
  let(:address) { described_class.new(attributes) }

  describe '#id' do
    it 'exposes the id of the address' do
      expect(address.id).to eq('GB|RM|ENG|LONDON---LANE-SCRUBS')
    end
  end

  describe '#type' do
    it 'exposes the type of the address' do
      expect(address.type).to eq('Street')
    end
  end

  describe '#text' do
    it 'exposes the text of the address' do
      expect(address.text).to eq('Scrubs Lane')
    end
  end

  describe '#highlight' do
    it 'exposes the highlight of the address' do
      expect(address.highlight).to eq('0-6,7-11')
    end
  end

  describe '#description' do
    it 'exposes the description of the address' do
      expect(address.description).to eq('London - 208 Addresses')
    end
  end

  describe '#==' do
    context 'when the attributes are different' do
      it 'returns false' do
        address1 = Loqate::Address.new(attributes)
        address2 = Loqate::Address.new(attributes.merge(type: 'Postcode'))

        expect(address1).not_to eq(address2)
      end
    end

    context 'when the attributes are the same' do
      it 'returns true' do
        address1 = Loqate::Address.new(attributes)
        address2 = Loqate::Address.new(attributes)

        expect(address1).to eq(address2)
      end
    end
  end
end
