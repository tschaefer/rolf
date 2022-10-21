# frozen_string_literal: true

require_relative 'base'

class Rolf
  module App
    class QueryCommand < Rolf::App::BaseCommand
      parameter 'CITY', 'city, town or village name'
      parameter 'STREET', 'street name'
      parameter '[STATE]', 'optional federal state name'
      option '--full', :flag, 'print full address'
      option '--json', :flag, 'print full address in JSON format'

      def process(rolf)
        return rolf.to_json(pretty: true) if json?

        full = full? || rolf.addresses.size > 1
        full ? rolf.to_s : rolf.addresses.first.to_struct.postcode
      end

      def execute
        rolf = Rolf.new(city: city, street: street, state: state || '') # rubocop:disable Style/HashSyntax
        rolf.query(type: 'road')
        exit 1 if rolf.addresses.empty?

        puts process(rolf)
      rescue URI::InvalidURIError
        bailout('Bad parameter.')
      rescue StandardError => e
        bailout(e.cause || e.message)
      end
    end
  end
end
