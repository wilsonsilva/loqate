require 'loqate/mappers/generic_mapper'
require 'loqate/error'
require 'loqate/util'

module Loqate
  module Mappers
    # Transforms erroneous responses into concrete error objects.
    #
    # @api private
    #
    class ErrorMapper
      # Creates errors from an API response
      #
      # @return [Array<Error>] An array of errors
      #
      def map(items)
        items.map do |item|
          attributes = item.transform_keys { |attribute| Util.underscore(attribute) }
          attributes[:id] = attributes.delete(:error).to_i

          Loqate::Error.new(attributes)
        end
      end
    end
  end
end
