require 'loqate/util'

RSpec.describe Loqate::Util do
  describe '.camelize' do
    it 'converts a string to camel case' do
      symbol = described_class.camelize('format_1_field')
      expect(symbol).to eq('Format1Field')
    end
  end

  describe '.underscore' do
    it 'converts a string to snake case' do
      symbol = described_class.underscore(:POBoxNumber)
      expect(symbol).to eq(:po_box_number)
    end
  end
end
