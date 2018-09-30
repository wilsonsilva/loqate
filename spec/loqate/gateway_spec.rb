require 'loqate/gateway'

RSpec.describe Loqate::Gateway do
  let(:gateway) { described_class.new(api_key: 'fake') }

  describe '#address' do
    it 'returns an address gateway' do
      expect(gateway.address).to be_an_instance_of(Loqate::AddressGateway)
    end
  end
end
