require 'loqate/email/batch_email_validation'

RSpec.describe Loqate::Email::BatchEmailValidation do
  let(:attributes) do
    {
      status: 'Valid',
      email_address: 'contact@wilsonsilva.net',
      account: 'contact',
      domain: 'wilsonsilva.net',
      is_disposible: false,
      is_system_mailbox: false
    }
  end
  let(:email_validation) { described_class.new(attributes) }

  describe '#status' do
    it 'exposes the validity of the email' do
      expect(email_validation.status).to eq('Valid')
    end
  end

  describe '#email_address' do
    it 'exposes the email address being validated' do
      expect(email_validation.email_address).to eq('contact@wilsonsilva.net')
    end
  end

  describe '#account' do
    it 'exposes the local part of the email' do
      expect(email_validation.account).to eq('contact')
    end
  end

  describe '#domain' do
    it 'exposes the domain part of the email' do
      expect(email_validation.domain).to eq('wilsonsilva.net')
    end
  end

  describe '#is_disposible' do
    it 'exposes whether the email address provided is a disposable mailbox' do
      expect(email_validation.is_disposible).to eq(false)
    end
  end

  describe '#is_system_mailbox' do
    it 'exposes whether the email address is a system mailbox (e.g. sales@, support@, accounts@ etc)' do
      expect(email_validation.is_system_mailbox).to eq(false)
    end
  end

  describe '#valid?' do
    context 'when the status is Valid' do
      subject { described_class.new(attributes.merge(status: 'Valid')) }

      it { is_expected.to be_valid }
    end

    context 'when the status is not Valid' do
      subject { described_class.new(attributes.merge(status: 'Invalid')) }

      it { is_expected.not_to be_valid }
    end
  end

  describe '#invalid?' do
    context 'when the status is Invalid' do
      subject { described_class.new(attributes.merge(status: 'Invalid')) }

      it { is_expected.to be_invalid }
    end

    context 'when the status is something else' do
      subject { described_class.new(attributes.merge(status: 'Valid')) }

      it { is_expected.not_to be_invalid }
    end
  end

  describe '#unknown?' do
    context 'when the status is Unknown' do
      subject { described_class.new(attributes.merge(status: 'Unknown')) }

      it { is_expected.to be_unknown }
    end

    context 'when the status is something else' do
      subject { described_class.new(attributes.merge(status: 'Valid')) }

      it { is_expected.not_to be_unknown }
    end
  end

  describe '#unverified?' do
    context 'when the status is Accept_All' do
      subject { described_class.new(attributes.merge(status: 'Accept_All')) }

      it { is_expected.to be_unverified }
    end

    context 'when the status is something else' do
      subject { described_class.new(attributes.merge(status: 'Valid')) }

      it { is_expected.not_to be_unverified }
    end
  end
end
