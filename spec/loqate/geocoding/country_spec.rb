require 'loqate/geocoding/country'

RSpec.describe Loqate::Geocoding::Country do
  let(:location) do
    described_class.new(
      country_name: 'United Kingdom',
      country_iso2: 'GBR',
      country_iso3: 'GB',
      country_iso_number: 826
    )
  end

  describe '#country_name' do
    it 'exposes the name of the country' do
      expect(location.country_name).to eq('United Kingdom')
    end
  end

  describe '#country_iso2' do
    it 'exposes the ISO2 of the country' do
      expect(location.country_iso2).to eq('GBR')
    end
  end

  describe '#country_iso3' do
    it 'exposes the ISO3 of the country' do
      expect(location.country_iso3).to eq('GB')
    end
  end

  describe '#country_iso_number' do
    it 'exposes the ISO number of the country' do
      expect(location.country_iso_number).to eq(826)
    end
  end
end
