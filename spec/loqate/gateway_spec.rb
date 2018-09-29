require 'loqate/gateway'

RSpec.describe Loqate::Gateway do
  let(:gateway) { described_class.new(api_key: 'fake') }
end
