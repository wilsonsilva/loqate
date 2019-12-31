require 'loqate/result'

RSpec.describe Loqate::Result::Mixin do
  subject(:action) { klass.new }

  let(:klass) do
    Class.new do
      include Loqate::Result::Mixin
    end
  end

  describe '#Failure' do
    it 'returns a failure result' do
      expect(action.Failure(double)).to be_an_instance_of(Loqate::Result::Failure)
    end
  end

  describe '#Success' do
    it 'returns a success result' do
      expect(action.Success(double)).to be_an_instance_of(Loqate::Result::Success)
    end
  end

  describe '#unwrap_result_or_raise' do
    context 'when the result is a success' do
      it 'returns the result value' do
        result = action.unwrap_result_or_raise { Loqate::Result::Success.new(value: 'ok') }
        expect(result).to eq('ok')
      end
    end

    context 'when the result is not a success' do
      let(:error) { StandardError.new('404') }

      it 'raises an error' do
        expect do
          action.unwrap_result_or_raise { Loqate::Result::Failure.new(value: error) }
        end.to raise_error(error)
      end
    end
  end
end
