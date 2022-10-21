# frozen_string_literal: true

require 'json'

class Rolf
  ##
  # Parse and prepare json formatted https://openstreetmap.org search result
  # data.
  class Address
    # Address record.
    attr_reader :record

    ##
    # Create new object with address record as simple struct.
    def initialize(osm_record:)
      record = osm_record['address']
               .except('country', 'country_code', 'continent')
               .transform_keys(&:to_sym)
      @record = Struct.new(*record.keys).new(*record.values)
    end

    # Verify address belongs to city.
    def city?(city)
      %i[city village town].each do |place|
        return true if @record.to_h.key?(place) &&
                       @record[place].match(/#{city}/i)
      end

      false
    end

    # Verify address is from type road.
    def road?
      type?(:road)
    end

    # Return address as simple struct.
    def to_struct
      @record
    end

    # Verify address is from given type.
    def type?(type)
      to_h.keys.first.eql?(type.to_sym)
    end

    # Return address as hash.
    def to_h
      @record.to_h
    end

    # Return address as JSON optional pretty formatted.
    def to_json(pretty: false)
      pretty ? JSON.pretty_generate(to_h) : JSON.generate(to_h)
    end

    # Return address as comma seperated string.
    def to_s
      to_h.values.join(', ')
    end
  end
end
