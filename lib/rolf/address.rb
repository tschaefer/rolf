# frozen_string_literal: true

require 'pp'
require 'json'

module Rolf
  class Address
    attr_reader :record

    def initialize(data)
      record = data['address']
               .except('country', 'country_code', 'continent')
               .transform_keys(&:to_sym)
      @record = Struct.new(*record.keys).new(*record.values)
    end

    def city?(city)
      %i[city village town].each do |place|
        return true if @record.to_h.key?(place) &&
                       @record[place].match(/#{city}/i)
      end

      false
    end

    def road?
      type?(:road)
    end

    def type?(type)
      to_h.keys.first.eql?(type.to_sym)
    end

    def to_h
      @record.to_h
    end

    def to_json(pretty: false)
      pretty ? JSON.pretty_generate(to_h) : JSON.generate(to_h)
    end

    def to_struct
      @record
    end
  end
end
