require 'loqate/util'

module Loqate
  module Mappers
    # Transforms arrays of hashes into concrete instances of classes.
    #
    # @api private
    #
    class GenericMapper
      # Creates objects from an API response. The objects will be an instance of +object_class+.
      #
      # @param [Class] object_class Class of the final objects
      # @param [Array<Hash>] items Array of attributes to instantiate the final objects
      #
      # @return An array of objects of the given class
      #
      def map(items, object_class)
        items.map do |item|
          attributes = item.transform_keys { |attribute| Util.underscore(attribute) }
          object_class.new(attributes)
        end
      end
    end
  end
end
