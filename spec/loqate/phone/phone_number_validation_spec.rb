require 'loqate/phone/phone_number_validation'

RSpec.describe Loqate::Phone::PhoneNumberValidation do
  let(:attributes) do
    {
      phone_number: '+447440019210',
      request_processed: true,
      is_valid: 'Yes',
      network_code: '26',
      network_name: 'Telefonica UK',
      network_country: 'GB',
      national_format: '07440 019210',
      country_prefix: 44,
      number_type: 'Mobile'
    }
  end
  let(:phone_number) { described_class.new(attributes) }

  describe '#phone_number' do
    it 'exposes the recipient phone number in international format' do
      expect(phone_number.phone_number).to eq('+447440019210')
    end
  end

  describe '#request_processed' do
    it 'exposes true if Loqate processed the request on the network' do
      expect(phone_number.request_processed).to eq(true)
    end
  end

  describe '#is_valid' do
    it 'exposes whether the number is valid or not' do
      expect(phone_number.is_valid).to eq('Yes')
    end
  end

  describe '#network_code' do
    it 'exposes the current operator serving the supplied number' do
      expect(phone_number.network_code).to eq('26')
    end
  end

  describe '#network_name' do
    it 'exposes the name of the current operator serving the supplied number' do
      expect(phone_number.network_name).to eq('Telefonica UK')
    end
  end

  describe '#network_country' do
    it 'exposes the country code of the operator' do
      expect(phone_number.network_country).to eq('GB')
    end
  end

  describe '#national_format' do
    it 'exposes the domestic network format' do
      expect(phone_number.national_format).to eq('07440 019210')
    end
  end

  describe '#country_prefix' do
    it 'exposes the country prefix that must be prepended to the number when dialling internationally' do
      expect(phone_number.country_prefix).to eq(44)
    end
  end

  describe '#number_type' do
    it 'exposes the number type' do
      expect(phone_number.number_type).to eq('Mobile')
    end
  end

  describe '#==' do
    context 'when the attributes are different' do
      it 'returns false' do
        number_validation1 = described_class.new(attributes)
        number_validation2 = described_class.new(attributes.merge(network_name: 'Giffgaff'))

        expect(number_validation1).not_to eq(number_validation2)
      end
    end

    context 'when the attributes are the same' do
      it 'returns true' do
        number_validation1 = described_class.new(attributes)
        number_validation2 = described_class.new(attributes)

        expect(number_validation1).to eq(number_validation2)
      end
    end
  end

  describe '#valid?' do
    context 'when the validation result is Yes' do
      subject { described_class.new(attributes.merge(is_valid: 'Yes')) }

      it { is_expected.to be_valid }
    end

    context 'when the validation result is No' do
      subject { described_class.new(attributes.merge(is_valid: 'No')) }

      it { is_expected.not_to be_valid }
    end

    context 'when the validation result is Unknown' do
      subject { described_class.new(attributes.merge(is_valid: 'Unknown')) }

      it { is_expected.not_to be_valid }
    end
  end
end
