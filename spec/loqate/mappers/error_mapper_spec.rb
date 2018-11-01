require 'loqate/mappers/error_mapper'

RSpec.describe Loqate::Mappers::ErrorMapper do
  let(:error_mapper) { described_class.new }

  describe '#map' do
    let(:errors_hashes) do
      [
        {
          Error: '1004',
          Description: 'Language Invalid',
          Cause: 'The Language parameter was not recognised.',
          Resolution: 'Please check what you entered and try again.'
        },
        {
          Error: '1006',
          Description: 'Invalid Input',
          Cause: 'Bad input detected.',
          Resolution: 'Please check what you entered and try again.'
        }
      ]
    end

    it 'transforms an array of hashes into concrete Error instances' do
      errors = error_mapper.map(errors_hashes)

      expect(errors).to contain_exactly(
        Loqate::Error.new(
          id: 1004,
          description: 'Language Invalid',
          cause: 'The Language parameter was not recognised.',
          resolution: 'Please check what you entered and try again.'
        ),
        Loqate::Error.new(
          id: 1006,
          description: 'Invalid Input',
          cause: 'Bad input detected.',
          resolution: 'Please check what you entered and try again.'
        )
      )
    end
  end

  describe '#map_one' do
    let(:error_hash) do
      {
        Error: '1004',
        Description: 'Language Invalid',
        Cause: 'The Language parameter was not recognised.',
        Resolution: 'Please check what you entered and try again.'
      }
    end

    it 'transforms a hash into a concrete Error instance' do
      error = error_mapper.map_one(error_hash)

      expect(error).to eq(
        Loqate::Error.new(
          id: 1004,
          description: 'Language Invalid',
          cause: 'The Language parameter was not recognised.',
          resolution: 'Please check what you entered and try again.'
        )
      )
    end
  end
end
