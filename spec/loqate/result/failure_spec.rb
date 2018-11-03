require 'loqate/result'

RSpec.describe Loqate::Result::Failure do
  subject(:failure) { described_class.new(value: error, code: error_code) }

  let(:error)      { double }
  let(:error_code) { double }

  it { is_expected.to be_failure }
  it { is_expected.not_to be_success }

  describe '#error' do
    it 'exposes the failure value' do
      expect(failure.error).to eq(error)
    end
  end

  describe '#value' do
    it 'exposes the failure value' do
      expect(failure.value).to eq(error)
    end
  end

  describe '#code' do
    it 'exposes the failure code' do
      expect(failure.code).to eq(error_code)
    end
  end
end
