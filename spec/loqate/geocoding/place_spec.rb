require 'loqate/geocoding/place'

RSpec.describe Loqate::Geocoding::Place do
  let(:place) do
    described_class.new(
      location: 'South Bathurst, NSW, Australia',
      distance: 0,
      latitude: -33.440113067627,
      longitude: 149.578567504883
    )
  end

  describe '#location' do
    it 'exposes the postcode that is nearest to the given location' do
      expect(place.location).to eq('South Bathurst, NSW, Australia')
    end
  end

  describe '#distance' do
    it 'exposes the distance in KM from the CentrePoint to this record' do
      expect(place.distance).to eq(0)
    end
  end

  describe '#latitude' do
    it 'exposes the WGS84 latitude coordinate of the location' do
      expect(place.latitude).to eq(-33.440113067627)
    end
  end

  describe '#longitude' do
    it 'exposes the WGS84 longitude coordinate of the location' do
      expect(place.longitude).to eq(149.578567504883)
    end
  end
end
