require 'loqate/geocoding/direction'

RSpec.describe Loqate::Geocoding::Direction do
  let(:direction) do
    described_class.new(
      action: 'L2',
      description: 'Turn left onto Carthusian Street',
      road: 'Carthusian Street',
      segment_number: 0,
      step_distance: 68,
      step_number: 1,
      step_time: 25,
      total_distance: 68,
      total_time: 25
    )
  end

  describe '#action' do
    it 'exposes the type of routing instruction' do
      expect(direction.action).to eq('L2')
    end
  end

  describe '#description' do
    it 'exposes the textual description of the routing instruction' do
      expect(direction.description).to eq('Turn left onto Carthusian Street')
    end
  end

  describe '#road' do
    it 'exposes the name of the road to turn onto' do
      expect(direction.road).to eq('Carthusian Street')
    end
  end

  describe '#segment_number' do
    it 'exposes the segment number' do
      expect(direction.segment_number).to eq(0)
    end
  end

  describe '#step_number' do
    it 'exposes a zero based counter indicating the row number' do
      expect(direction.step_number).to eq(1)
    end
  end

  describe '#step_time' do
    it 'exposes the time in seconds for this part of the route' do
      expect(direction.step_time).to eq(25)
    end
  end

  describe '#total_distance' do
    it 'exposes the total time in seconds for the route' do
      expect(direction.total_distance).to eq(68)
    end
  end

  describe '#total_time' do
    it 'exposes the total distance in metres for the route' do
      expect(direction.total_time).to eq(25)
    end
  end
end
