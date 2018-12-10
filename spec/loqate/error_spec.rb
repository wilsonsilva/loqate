require 'loqate/address/detailed_address'

RSpec.describe Loqate::Error do
  let(:error) { described_class.new(id: 1006, description: 'desc', cause: 'the cause', resolution: 'the resolution') }

  describe '#id' do
    it 'exposes the error id' do
      expect(error.id).to eq(1006)
    end
  end

  describe '#description' do
    it 'exposes the error description' do
      expect(error.description).to eq('desc')
    end
  end

  describe '#cause' do
    it 'exposes the error cause' do
      expect(error.cause).to eq('the cause')
    end
  end

  describe '#resolution' do
    it 'exposes the error resolution' do
      expect(error.resolution).to eq('the resolution')
    end
  end

  describe '#==' do
    context 'when the errors have the same id' do
      let(:error2) do
        described_class.new(id: 1006, description: 'different', cause: 'different', resolution: 'different')
      end

      it 'returns true' do
        expect(error).to eq(error2)
      end
    end

    context 'when the errors do not have the same id' do
      let(:error2) do
        described_class.new(id: 1, description: 'different', cause: 'different', resolution: 'different')
      end

      it 'returns false' do
        expect(error).not_to eq(error2)
      end
    end

    context 'when comparing with another class' do
      let(:error2) { instance_double('Loqate::Error', id: 1006) }

      it 'returns true' do
        expect(error).not_to eq(error2)
      end
    end
  end
end
