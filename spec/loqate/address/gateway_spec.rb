require 'loqate/address/gateway'

RSpec.describe Loqate::Address::Gateway, vcr: true do
  let(:dev_api_key)     { File.read("#{File.dirname(__FILE__)}/../../../.api_key").strip }
  let(:configuration)   { Loqate::Configuration.new(api_key: dev_api_key) }
  let(:client)          { Loqate::Client.new(configuration) }
  let(:address_gateway) { described_class.new(client) }

  describe '#find' do
    context 'when invoked with wrong parameters' do
      it 'returns an error' do
        result = address_gateway.find(countries: 'GB', texto: 'NW10 6RB')
        expect(result).to be_failure
      end
    end

    context 'when searching with wrong parameters' do
      let(:error) do
        Loqate::Error.new(
          cause: 'The Text or Container parameters were not supplied.',
          description: 'Text or Container Required',
          id: 1001,
          resolution: 'Check they were supplied and try again.'
        )
      end

      it 'returns a list of errors' do
        result = address_gateway.find(text: nil)
        expect(result.value).to eq(error)
      end
    end

    context 'when searching by a postcode' do
      it 'returns a list of addresses' do
        result = address_gateway.find(countries: 'GB', text: 'NW10 6RB')
        expect(result.value).to contain_exactly(
          Loqate::Address::Address.new(
            description: 'Scrubs Lane, London - 17 Addresses',
            highlight: '0-4,5-8',
            id: 'GB|RM|ENG|6RB-NW10',
            text: 'NW10 6RB',
            type: 'Postcode'
          )
        )
      end
    end

    context 'when searching by street name' do
      it 'returns a list of addresses' do
        result = address_gateway.find(countries: 'GB', text: 'Scrubs Lane')
        expect(result.value).to contain_exactly(
          Loqate::Address::Address.new(
            description: 'London - 209 Addresses',
            highlight: '0-6,7-11',
            id: 'GB|RM|ENG|LONDON---LANE-SCRUBS',
            text: 'Scrubs Lane',
            type: 'Street'
          ),
          Loqate::Address::Address.new(
            description: 'Danbury, Chelmsford, CM3 4NZ',
            highlight: '0-6',
            id: 'GB|RM|B|27570297|A1',
            text: 'Scrubs, 21 Runsell Lane',
            type: 'Address'
          )
        )
      end
    end

    context 'when limit is specified' do
      it 'returns a limited set of addresses' do
        result = address_gateway.find(countries: 'GB', text: 'Scrubs Lane', limit: 1)
        expect(result.value).to contain_exactly(
          Loqate::Address::Address.new(
            description: 'London - 208 Addresses',
            highlight: '0-6,7-11',
            id: 'GB|RM|ENG|LONDON---LANE-SCRUBS',
            text: 'Scrubs Lane',
            type: 'Street'
          )
        )
      end
    end
  end

  describe '#retrieve' do
    context 'when the id is invalid' do
      let(:error) do
        Loqate::Error.new(
          cause: 'The Id parameter supplied was invalid.',
          description: 'Id Invalid',
          id: 1001,
          resolution: 'You should only pass in IDs that have been returned from the Find service.'
        )
      end

      it 'returns a list of errors' do
        result = address_gateway.retrieve(id: 'GB|RM|ENG|6RB-NW10')
        expect(result.value).to eq(error)
      end
    end

    context 'when there is no error' do
      it 'returns detailed addresses' do
        result = address_gateway.retrieve(id: 'GB|RM|B|52509479')
        expect(result.value).to eq(
          Loqate::Address::DetailedAddress.new(
            id: 'GB|RM|B|52509479',
            domestic_id: '52509479',
            language: 'ENG',
            language_alternatives: 'ENG'
          )
        )
      end
    end
  end

  describe '#find!' do
    context 'when the result is successful' do
      it 'returns the unwrapped result' do
        address = address_gateway.find!(countries: 'GB', text: 'NW10 6RB')

        expect(address).to contain_exactly(
          Loqate::Address::Address.new(
            description: 'Scrubs Lane, London - 18 Addresses',
            highlight: '0-4,5-8',
            id: 'GB|RM|ENG|6RB-NW10',
            text: 'NW10 6RB',
            type: 'Postcode'
          )
        )
      end
    end

    context 'when the result is not successful' do
      it 'raises an error' do
        expect do
          address_gateway.find!(countries: 'GB', texto: 'NW10 6RB')
        end.to raise_error(Loqate::Error, 'Text or Container Required')
      end
    end
  end

  describe '#retrieve!' do
    context 'when the result is successful' do
      it 'returns the unwrapped result' do
        address = address_gateway.retrieve!(id: 'GB|RM|B|52509479')

        expect(address).to eq(
          Loqate::Address::DetailedAddress.new(
            id: 'GB|RM|B|52509479',
            domestic_id: '52509479',
            language: 'ENG',
            language_alternatives: 'ENG'
          )
        )
      end
    end

    context 'when the result is not successful' do
      it 'raises an error' do
        expect do
          address_gateway.retrieve!(id: nil)
        end.to raise_error(Loqate::Error, 'Id Invalid')
      end
    end
  end
end
