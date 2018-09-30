require 'loqate/mappers/generic_mapper'
require 'loqate/address'

RSpec.describe Loqate::Mappers::GenericMapper do
  let(:generic_mapper) { described_class.new }

  describe '#map' do
    let(:address_hashes) do
      [
        {
          Id: 'GB|RM|B|8144612',
          Type: 'Postcode',
          Text: 'WC0 9BK',
          Highlight: '20-12',
          Description: 'The Address'
        }
      ]
    end

    it 'transforms an array of hashes into objects of a given class' do
      addresses = generic_mapper.map(address_hashes, Loqate::Address)

      expect(addresses).to contain_exactly(
        Loqate::Address.new(
          id: 'GB|RM|B|8144612',
          type: 'Postcode',
          text: 'WC0 9BK',
          highlight: '20-12',
          description: 'The Address'
        )
      )
    end
  end
end
