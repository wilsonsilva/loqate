require 'loqate/configuration'

RSpec.describe Loqate::Configuration do
  let(:host)          { 'https://api.example.com' }
  let(:api_key)       { 'TD53-AM95-WZ07-RZ81' }
  let(:language)      { 'fr' }
  let(:configuration) { described_class.new(host: host, api_key: api_key, language: language) }

  describe '#initialize' do
    context 'when the language is not specified' do
      it 'instantiates the configuration with a default language' do
        config = described_class.new(api_key: api_key)

        expect(config.language).to eq(described_class::DEFAULT_LANGUAGE)
      end
    end

    context 'when the host is not specified' do
      it 'instantiates the configuration with a default host' do
        config = described_class.new(api_key: api_key)

        expect(config.host).to eq(described_class::DEFAULT_HOST)
      end
    end
  end

  describe '#api_key' do
    it 'exposes the API key' do
      expect(configuration.api_key).to eq(api_key)
    end
  end

  describe '#host' do
    it 'exposes the host' do
      expect(configuration.host).to eq(host)
    end
  end

  describe '#language' do
    it 'exposes the language' do
      expect(configuration.language).to eq(language)
    end
  end
end
