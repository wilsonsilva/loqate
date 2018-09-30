require 'loqate/result'

RSpec.describe Loqate::Result::Success do
  subject { described_class.new(value: double) }

  it { is_expected.to be_success }
  it { is_expected.not_to be_failure }
end
