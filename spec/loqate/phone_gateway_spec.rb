require 'loqate/phone_gateway'

RSpec.describe Loqate::PhoneGateway, vcr: true do
  let(:dev_api_key)   { File.read(File.dirname(__FILE__) + '/../../.api_key').strip }
  let(:configuration) { Loqate::Configuration.new(api_key: dev_api_key) }
  let(:client)        { Loqate::Client.new(configuration) }
  let(:phone_gateway) { described_class.new(client) }

  describe '#validate' do
    context 'when invoked without a phone' do
      let(:error) do
        Loqate::Error.new(
          cause: 'The phone numbers is required.',
          description: 'Number Required',
          id: 1001,
          resolution: 'Please ensure that you supply a phone number and try again.'
        )
      end

      it 'returns an error' do
        result = phone_gateway.validate(country: 'GB')
        expect(result.value).to eq(error)
      end
    end

    context 'when the phone number is invalid' do
      it 'returns an invalid phone number validation' do
        result = phone_gateway.validate(phone: '0', country: 'GB')

        expect(result.value).to eq(
          Loqate::PhoneNumberValidation.new(
            phone_number: '',
            request_processed: true,
            is_valid: 'No',
            network_code: '',
            network_name: '',
            network_country: '',
            national_format: '',
            country_prefix: 0,
            number_type: 'Unknown'
          )
        )
      end
    end

    context 'when the phone number is valid' do
      it 'returns a valid phone number validation' do
        result = phone_gateway.validate(phone: '447440029210', country: 'GB')

        expect(result.value).to eq(
          Loqate::PhoneNumberValidation.new(
            phone_number: '+447440029210',
            request_processed: true,
            is_valid: 'Yes',
            network_code: '26',
            network_name: 'Telefonica UK',
            network_country: 'GB',
            national_format: '07440 029210',
            country_prefix: 44,
            number_type: 'Mobile'
          )
        )
      end
    end
  end

  describe '#validate!' do
    context 'when the result is successful' do
      it 'returns the unwrapped result' do
        phone_validation_result = phone_gateway.validate!(phone: '447440029210', country: 'GB')

        expect(phone_validation_result).to eq(
          Loqate::PhoneNumberValidation.new(
            phone_number: '+447440029210',
            request_processed: true,
            is_valid: 'Yes',
            network_code: '26',
            network_name: 'Telefonica UK',
            network_country: 'GB',
            national_format: '07440 029210',
            country_prefix: 44,
            number_type: 'Mobile'
          )
        )
      end
    end

    context 'when the result is not successful' do
      it 'raises an error' do
        expect do
          phone_gateway.validate!(phonee: '447440029210')
        end.to raise_error(Loqate::Error, 'Number Required')
      end
    end
  end
end
