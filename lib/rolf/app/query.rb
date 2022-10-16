# frozen_string_literal: true

require_relative 'base'

module Rolf
  module App
    class QueryCommand < Rolf::App::BaseCommand
      parameter 'CITY', 'city, town or village name'
      parameter 'STREET', 'street name'
      parameter '[STATE]', 'optional federal state name'
      option '--full', :flag, 'print full address'
      option '--json', :flag, 'print full address in JSON format'

      def process(addresses)
        return addresses.map { |address| address.to_json(pretty: true) } if json?

        full = full? || addresses.size > 1
        addresses.map do |address|
          if full
            address.to_h.values.join(', ')
          else
            address.record.postcode
          end
        end.join("\n")
      end

      def execute
        rolf = Rolf.new(city: city, street: street, state: state || '') # rubocop:disable Style/HashSyntax
        addresses = rolf.query(type: 'road')
        exit 1 if addresses.empty?

        puts process(addresses)
      rescue URI::InvalidURIError
        bailout('Bad parameter.')
      rescue StandardError => e
        bailout(e.cause || e.message)
      end
    end
  end
end
