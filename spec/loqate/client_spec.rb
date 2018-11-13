RSpec.describe Loqate::Client do
  let(:api_key) { 'fake' }
  let(:configuration) { Loqate::Configuration.new(api_key: api_key) }
  let(:client) { described_class.new(configuration) }

  describe '#get' do
    it 'performs a GET request to a specified endpoint with a preconfigured API key' do
      stub_request(:get, 'https://api.addressy.com/path?Key=fake').to_return(body: '{"Items": []}')

      client.get('/path')
      expect(WebMock).to have_requested(:get, 'https://api.addressy.com/path?Key=fake')
    end

    it 'appends the options as query parameters' do
      stub_request(:get, 'https://api.addressy.com/path?Key=fake&Q1=val1').to_return(body: '{"Items": []}')

      client.get('/path', q1: 'val1')
      expect(WebMock).to have_requested(:get, 'https://api.addressy.com/path?Key=fake&Q1=val1')
    end

    it 'requests content in the JSON format' do
      stub_request(:get, 'https://api.addressy.com/path?Key=fake').to_return(body: '{"Items": []}')

      client.get('/path')
      expect(WebMock).to have_requested(:get, 'https://api.addressy.com/path?Key=fake').with(
        headers: { accept: 'application/json' }
      )
    end

    it 'returns a response object' do
      stub_request(:get, 'https://api.addressy.com/path?Key=fake').to_return(body: '{"Items": []}')

      response = client.get('/path')
      expect(response.items).to be_empty
    end

    context 'when the host is configured' do
      let(:configuration) { Loqate::Configuration.new(api_key: api_key, host: 'http://example.com') }
      let(:client) { described_class.new(configuration) }

      it 'performs a request to a preconfigured host' do
        stub_request(:get, 'http://example.com/path?Key=fake').to_return(body: '{"Items": []}')

        client.get('/path')
        expect(WebMock).to have_requested(:get, 'http://example.com/path?Key=fake')
      end
    end
  end
end
