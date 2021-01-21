require 'loqate/email/email_validation'

RSpec.describe Loqate::Email::EmailValidation do
  let(:duration) { 0.241566504 }
  let(:attributes) do
    {
      response_code: 'Valid',
      response_message: 'Email address was fully validated',
      email_address: 'contact@wilsonsilva.net',
      user_account: 'contact',
      domain: 'wilsonsilva.net',
      is_disposable_or_temporary: false,
      is_complainer_or_fraud_risk: false,
      duration: duration
    }
  end
  let(:email_validation) { described_class.new(attributes) }

  describe 'attributes coercion' do
    context 'when the duration cannot be coerced into a float' do
      let(:duration) { 'not-a-coercible-float' }

      it 'raises an error' do
        expect { email_validation }.to raise_error(Dry::Struct::Error, /invalid type for :duration/)
      end
    end

    context 'when the duration is an integer' do
      let(:duration) { 1 }

      it 'coerces the duration into a float' do
        expect(email_validation.duration).to eq(1.0)
      end
    end

    context 'when the duration is a string' do
      let(:duration) { '0.367289412' }

      it 'coerces the duration into a float' do
        expect(email_validation.duration).to eq(0.367289412)
      end
    end
  end

  describe '#response_code' do
    it 'exposes the validity of the email' do
      expect(email_validation.response_code).to eq('Valid')
    end
  end

  describe '#response_message' do
    it 'exposes the description of the validation' do
      expect(email_validation.response_message).to eq('Email address was fully validated')
    end
  end

  describe '#email_address' do
    it 'exposes the email address being validated' do
      expect(email_validation.email_address).to eq('contact@wilsonsilva.net')
    end
  end

  describe '#user_account' do
    it 'exposes the local part of the email' do
      expect(email_validation.user_account).to eq('contact')
    end
  end

  describe '#domain' do
    it 'exposes the domain part of the email' do
      expect(email_validation.domain).to eq('wilsonsilva.net')
    end
  end

  describe '#is_disposable_or_temporary' do
    it 'exposes whether the email address provided is a disposable mailbox' do
      expect(email_validation.is_disposable_or_temporary).to eq(false)
    end
  end

  describe '#is_complainer_or_fraud_risk' do
    it 'exposes whether the email address has been flagged as fraud or recognized as a complainer' do
      expect(email_validation.is_complainer_or_fraud_risk).to eq(false)
    end
  end

  describe '#duration' do
    it 'exposes the duration (in seconds) that the email validation took' do
      expect(email_validation.duration).to eq(duration)
    end
  end

  describe '#valid?' do
    context 'when the response code is Valid' do
      subject { described_class.new(attributes.merge(response_code: 'Valid')) }

      it { is_expected.to be_valid }
    end

    context 'when the response code is Valid_CatchAll' do
      subject { described_class.new(attributes.merge(response_code: 'Valid_CatchAll')) }

      it { is_expected.not_to be_valid }
    end

    context 'when the response code is Invalid' do
      subject { described_class.new(attributes.merge(response_code: 'Invalid')) }

      it { is_expected.not_to be_valid }
    end

    context 'when the response code is Timeout' do
      subject { described_class.new(attributes.merge(response_code: 'Timeout')) }

      it { is_expected.not_to be_valid }
    end
  end

  describe '#valid_domain?' do
    context 'when the response code is Valid' do
      subject { described_class.new(attributes.merge(response_code: 'Valid')) }

      it { is_expected.to be_valid_domain }
    end

    context 'when the response code is Valid_CatchAll' do
      subject { described_class.new(attributes.merge(response_code: 'Valid_CatchAll')) }

      it { is_expected.to be_valid_domain }
    end

    context 'when the response code is something else' do
      subject { described_class.new(attributes.merge(response_code: 'Invalid')) }

      it { is_expected.not_to be_valid_domain }
    end
  end

  describe '#invalid?' do
    context 'when the response code is Invalid' do
      subject { described_class.new(attributes.merge(response_code: 'Invalid')) }

      it { is_expected.to be_invalid }
    end

    context 'when the response code is something else' do
      subject { described_class.new(attributes.merge(response_code: 'Valid')) }

      it { is_expected.not_to be_invalid }
    end
  end

  describe '#timeout?' do
    context 'when the response code is Timeout' do
      subject { described_class.new(attributes.merge(response_code: 'Timeout')) }

      it { is_expected.to be_timeout }
    end

    context 'when the response code is something else' do
      subject { described_class.new(attributes.merge(response_code: 'Valid')) }

      it { is_expected.not_to be_timeout }
    end
  end
end
