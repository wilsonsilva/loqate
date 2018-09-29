require 'loqate/api_result'

RSpec.describe Loqate::APIResult do
  describe '#items' do
    let(:items)  { [{ Id: 'GB|RM|ENG|6RB-NW10', Type: 'Postcode' }] }
    let(:result) { described_class.new(items) }

    it 'exposes the items' do
      expect(result.items).to eq(items)
    end
  end

  describe '#errors?' do
    context 'when the response contains errors' do
      let(:result) { described_class.new([{ 'Error' => '1001' }]) }

      it 'returns true' do
        expect(result.errors?).to eq(true)
      end
    end

    context 'when the response does not contain errors' do
      let(:result) { described_class.new([{ Id: 'GB|RM|ENG|6RB-NW10', Type: 'Postcode' }]) }

      it 'returns false' do
        expect(result.errors?).to eq(false)
      end
    end
  end
end
