require 'loqate/gateway'

RSpec.describe Loqate::Gateway do
  let(:gateway) { described_class.new(api_key: 'fake') }

  describe '#address' do
    it 'returns an address gateway' do
      expect(gateway.address).to be_an_instance_of(Loqate::AddressGateway)
    end
  end

  describe '#phone' do
    it 'returns a phone gateway' do
      expect(gateway.phone).to be_an_instance_of(Loqate::PhoneGateway)
    end
  end

  describe '#email' do
    it 'returns an email gateway' do
      expect(gateway.email).to be_an_instance_of(Loqate::EmailGateway)
    end
  end
end
