require 'loqate/geocoding/location'

RSpec.describe Loqate::Geocoding::Location do
  let(:location) do
    described_class.new(
      name: 'Beverly Hills, CA 90210',
      latitude: 34.1075775639288,
      longitude: -118.416587904777
    )
  end

  describe '#name' do
    it 'exposes the name of the location found' do
      expect(location.name).to eq('Beverly Hills, CA 90210')
    end
  end

  describe '#latitude' do
    it 'exposes the WGS84 latitude of the found location' do
      expect(location.latitude).to eq(34.1075775639288)
    end
  end

  describe '#longitude' do
    it 'exposes the WGS84 longitude of the found location' do
      expect(location.longitude).to eq(-118.416587904777)
    end
  end
end
