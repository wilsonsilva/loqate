require 'loqate/geocoding/gateway'

RSpec.describe Loqate::Geocoding::Gateway, vcr: true do
  let(:dev_api_key)   { File.read(File.dirname(__FILE__) + '/../../../.api_key').strip }
  let(:configuration) { Loqate::Configuration.new(api_key: dev_api_key) }
  let(:client)        { Loqate::Client.new(configuration) }
  let(:gateway)       { described_class.new(client) }

  describe '#directions' do
    context 'when invoked without start' do
      it 'returns an error' do
        result = gateway.directions(finish: [51.5078677, -0.1266825])

        expect(result.value).to eq(
          Loqate::Error.new(
            cause: 'The Start parameter was not supplied.',
            description: 'Start Required',
            id: 1001,
            resolution: 'Please ensure that you supply the Start parameter and try again.'
          )
        )
      end
    end

    context 'when invoked with an invalid start' do
      it 'returns an error' do
        result = gateway.directions(start: ['donuts', -0.1266053], finish: [51.5078677, -0.1266825])

        expect(result.value).to eq(
          Loqate::Error.new(
            cause: 'The Start parameter must be latitude + longitude separated by commas or a postcode or an easting, \
              northing coordinate pair separated by commas.',
            description: 'Start Invalid',
            id: 1002,
            resolution: 'Check the parameter and try again.'
          )
        )
      end
    end

    context 'when invoked without a finish' do
      it 'returns an error' do
        result = gateway.directions(start: [51.5079532, -0.1266053])

        expect(result.value).to eq(
          Loqate::Error.new(
            cause: 'The Finish parameter was not supplied.',
            description: 'Finish Required',
            id: 1003,
            resolution: 'Please ensure that you supply the Finish parameter and try again.'
          )
        )
      end
    end

    context 'when invoked with an invalid finish' do
      it 'returns an error' do
        result = gateway.directions(start: [51.5079532, -0.1266053], finish: ['donuts', -0.1266825])

        expect(result.value).to eq(
          Loqate::Error.new(
            cause: 'The Finish parameter must be latitude + longitude separated by commas or a postcode or an easting, \
              northing coordinate pair separated by commas.',
            description: 'Finish Invalid',
            id: 1004,
            resolution: 'Check the parameter and try again.'
          )
        )
      end
    end

    context 'when invoked with an invalid waypoint' do
      it 'returns an error' do
        result = gateway.directions(
          start: [51.5079532, -0.1266053],
          finish: [51.5078677, -0.1266825],
          waypoints: ['donuts']
        )

        expect(result.value).to eq(
          Loqate::Error.new(
            cause: 'Waypoints must be latitude + longitude separated by commas or a postcode or an easting, northing \
              coordinate pair separated by commas.',
            description: 'One or more Waypoints Invalid',
            id: 1005,
            resolution: 'Check the parameter and try again.'
          )
        )
      end
    end

    context 'when invoked with an invalid distance type' do
      it 'returns an error' do
        result = gateway.directions(
          start: [51.5079532, -0.1266053],
          finish: [51.5078677, -0.1266825],
          distance_type: 'donuts'
        )

        expect(result.value).to eq(
          Loqate::Error.new(
            cause: 'The DistanceType parameter was not recognised. Valid values are "Fastest" and "Shortest".',
            description: 'DistanceType Invalid',
            id: 1006,
            resolution: 'Check the DistanceType and try again.'
          )
        )
      end
    end

    context 'when invoked with an invalid route' do
      it 'returns an error' do
        result = gateway.directions(start: [51.5079532, -0.1266053], finish: [68.750934, -47.1674161])

        expect(result.value).to eq(
          Loqate::Error.new(
            cause: 'It was not possible to calculate a route. This is usually because one or more of the locations \
              were invalid, too far from the road network or no route exists between the locations.',
            description: 'Route Not Possible',
            id: 1007,
            resolution: 'Check all the locations and try again.'
          )
        )
      end
    end

    context 'when invoked with an invalid start day' do
      it 'returns an error' do
        result = gateway.directions(
          start: [51.5079532, -0.1266053],
          finish: [51.5078677, -0.1266825],
          start_day: 'donuts',
          start_time: 510
        )

        expect(result.value).to eq(
          Loqate::Error.new(
            cause: 'The StartDay parameter was not recognised.',
            description: 'StartDay invalid',
            id: 1008,
            resolution: 'Ensure the StartDay parameter is one of the exact given values.'
          )
        )
      end
    end

    context 'when invoked with an invalid start time' do
      it 'returns an error' do
        result = gateway.directions(
          start: [51.5079532, -0.1266053],
          finish: [51.5078677, -0.1266825],
          start_day: 'Monday',
          start_time: 'donuts'
        )

        expect(result.value).to eq(
          Loqate::Error.new(
            cause: 'The StartTime parameter was incorrect.',
            description: 'StartTime invalid',
            id: 1009,
            resolution: 'Ensure the StartTime parameter is an integer between 0 and 1439.'
          )
        )
      end
    end

    context 'when invoked with a start day but no start time' do
      it 'returns an error' do
        result = gateway.directions(
          start: [51.5079532, -0.1266053],
          finish: [51.5078677, -0.1266825],
          start_day: 'Monday'
        )

        expect(result.value).to eq(
          Loqate::Error.new(
            cause: 'If either StartDay or StartTime is provided, both must be provided.',
            description: 'StartDay or StartTime not provided',
            id: 1010,
            resolution: 'Ensure both or neither of the StartDay and StartTime parameters are provided.'
          )
        )
      end
    end

    context 'when invoked with a start time but no start day' do
      it 'returns an error' do
        result = gateway.directions(
          start: [51.5079532, -0.1266053],
          finish: [51.5078677, -0.1266825],
          start_time: 510
        )

        expect(result.value).to eq(
          Loqate::Error.new(
            cause: 'If either StartDay or StartTime is provided, both must be provided.',
            description: 'StartDay or StartTime not provided',
            id: 1010,
            resolution: 'Ensure both or neither of the StartDay and StartTime parameters are provided.'
          )
        )
      end
    end

    context 'when finding directions by postcodes' do
      it 'returns the directions' do
        result = gateway.directions(
          start: 'EC1A 4JA',
          finish: 'EC1A 4ER'
        )

        expect(result.value).to all(be_an_instance_of(Loqate::Geocoding::Direction))
      end
    end

    context 'when finding directions with waypoints' do
      it 'returns the directions' do
        result = gateway.directions(
          start: 'EC1A 4JA',
          finish: 'EC1A 4ER',
          way_points: ['EC1A 4JQ']
        )

        expect(result.value).to all(be_an_instance_of(Loqate::Geocoding::Direction))
      end
    end

    context 'when finding directions in a given time' do
      it 'returns the directions' do
        result = gateway.directions(
          start: [51.5079532, -0.1266053],
          finish: [51.5078677, -0.1266825],
          start_day: 'Monday',
          start_time: 510
        )

        expect(result.value).to all(be_an_instance_of(Loqate::Geocoding::Direction))
      end
    end

    context 'when finding directions by easting and northing coordinates' do
      it 'returns the directions' do
        result = gateway.directions(
          start: [381_600, 259_400],
          finish: [380_600, 258_400]
        )

        expect(result.value).to all(be_an_instance_of(Loqate::Geocoding::Direction))
      end
    end

    context 'when finding directions by latitude and longitude coordinates' do
      it 'returns the directions' do
        result = gateway.directions(
          start: [51.5079532, -0.1266053],
          finish: [51.5078677, -0.1266825]
        )

        expect(result.value).to eq(
          [
            Loqate::Geocoding::Direction.new(
              segment_number: 0,
              step_number: 0,
              action: 'D',
              description: 'Leave from Strand/A4',
              road: 'Strand',
              step_time: 0,
              step_distance: 0,
              total_time: 0,
              total_distance: 0
            ),
            Loqate::Geocoding::Direction.new(
              segment_number: 0,
              step_number: 1,
              action: 'A',
              description: 'You have arrived at Strand/A4. Your destination is on the right',
              road: 'Strand',
              step_time: 7,
              step_distance: 10,
              total_time: 7,
              total_distance: 10
            )
          ]
        )
      end
    end
  end

  describe '#directions!' do
    context 'when the result is successful' do
      it 'returns the unwrapped result' do
        directions = gateway.directions!(
          start: [51.5079532, -0.1266053],
          finish: [51.5078677, -0.1266825]
        )

        expect(directions).to all(be_an_instance_of(Loqate::Geocoding::Direction))
      end
    end

    context 'when the result is not successful' do
      it 'raises an error' do
        expect do
          gateway.directions!(finish: [51.5078677, -0.1266825])
        end.to raise_error(Loqate::Error, 'Start Required')
      end
    end
  end

  describe '#geocode' do
    context 'when invoked without country' do
      it 'returns an error' do
        result = gateway.geocode(location: '90210')

        # According to the official documentation, this should return the error 1001.
        expect(result.value).to eq(
          Loqate::Error.new(
            cause: 'The Country parameter was not recognised. Check the spelling and, if in doubt, use a valid ISO 2 \
              or 3 digit country code.',
            description: 'Country Required',
            id: 1002,
            resolution: 'Provide a valid ISO 2 or 3 digit country code or use a web service to convert country name \
              to ISO code.'
          )
        )
      end
    end

    context 'when invoked with an unknown country' do
      it 'returns an error' do
        result = gateway.geocode(country: 'LOL', location: '90210')

        expect(result.value).to eq(
          Loqate::Error.new(
            cause: 'The Country parameter was not recognised. Check the spelling and, if in doubt, use a valid ISO 2 \
              or 3 digit country code.',
            description: 'Country Required',
            id: 1002,
            resolution: 'Provide a valid ISO 2 or 3 digit country code or use a web service to convert country name \
              to ISO code.'
          )
        )
      end
    end

    context 'when invoked without a location' do
      it 'returns an error' do
        result = gateway.geocode(country: 'US')

        expect(result.value).to eq(
          Loqate::Error.new(
            cause: 'No Location data was supplied but one is needed.',
            description: 'Location Required',
            id: 1003,
            resolution: 'Please ensure that you supply a location and try again.'
          )
        )
      end
    end

    context 'when invoked with a country and a location' do
      it 'geocodes a location' do
        result = gateway.geocode(country: 'US', location: '90210')

        expect(result.value).to eq(
          Loqate::Geocoding::Location.new(
            name: 'Beverly Hills, CA 90210',
            latitude: 34.08057,
            longitude: -118.40033
          )
        )
      end
    end
  end

  describe '#geocode!' do
    context 'when the result is successful' do
      it 'returns the unwrapped result' do
        location = gateway.geocode!(country: 'US', location: '90210')

        expect(location).to be_an_instance_of(Loqate::Geocoding::Location)
      end
    end

    context 'when the result is not successful' do
      it 'raises an error' do
        expect do
          gateway.geocode!(country: 'LOL', location: '90210')
        end.to raise_error(Loqate::Error, 'Country Unknown')
      end
    end
  end
end
