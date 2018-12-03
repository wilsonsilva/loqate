module Loqate
  module Address
    # A result from the address retrieve service.
    class DetailedAddress
      # For the first version, this will be a flat structure, exactly as it is defined in Loqate's API.
      # But this many attributes is too much for a single object to hold.
      #
      # @api private
      #
      ATTRIBUTES = %i[
        admin_area_code
        admin_area_name
        barcode
        block
        building_name
        building_number
        city
        company
        country_iso2
        country_iso3
        country_iso_number
        country_name
        data_level
        department
        district
        domestic_id
        field1
        field2
        field3
        field4
        field5
        field6
        field7
        field8
        field9
        field10
        field11
        field12
        field13
        field14
        field15
        field16
        field17
        field18
        field19
        field20
        id
        label
        language
        language_alternatives
        line1
        line2
        line3
        line4
        line5
        neighbourhood
        po_box_number
        postal_code
        province
        province_code
        province_name
        secondary_street
        sorting_number1
        sorting_number2
        street
        sub_building
        type
      ].freeze

      ATTRIBUTES.each do |attribute|
        attr_reader attribute
      end

      def initialize(options = {})
        options.each_pair do |key, value|
          instance_variable_set("@#{key}", value) if ATTRIBUTES.include?(key)
        end
      end

      def ==(other)
        other.is_a?(DetailedAddress) && id == other.id
      end
    end
  end
end
