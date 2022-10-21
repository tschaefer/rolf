# frozen_string_literal: true

require 'faraday'

require 'rolf/address'

##
# Query full german addresses including postalcodes.
#
#   Rolf.new(city: 'Garmisch-Partenkirchen', street: 'Zugspitzstrasse').query(type: 'road')
#   [
#     {
#       "road": "Zugspitzstraße",
#       "town": "Garmisch-Partenkirchen",
#       "county": "Landkreis Garmisch-Partenkirchen",
#       "state_district": "Obb",
#       "state": "Bayern",
#       "postcode": "82467"
#     }
#   ]
#
# All necessary information are gathered from https://openstreetmap.org data
# via https://nominatim.org API.
#
# The base url to the API may be set via environment variable, e.g.
#
#   ROLF_BASE_URL='https://nominatim.openstreetmap.org'
class Rolf
  # :nodoc:
  BASE_URL  = 'https://names.geo.core.io'
  QUERY_URL = '%s/search.php?countrycode=de&%s&addressdetails=1&format=jsonv2'
  # :doc:

  # Query results.
  attr_reader :addresses

  # Initialize object with city (town, village), street and optional
  # federal state name.
  def initialize(city:, street:, state: nil)
    @addresses = []
    @terms = { city:, street:, state: }
    @url = URI(format(
                 QUERY_URL,
                 ENV['ROLF_BASE_URL'] || BASE_URL,
                 url_params
               ))
  end

  # Query addresses and optional filter type with OSM tag
  # (e.g. 'road', 'bus_stop').
  # Returns an uniq array of Rolf::Address objects.
  def query(type: nil)
    response = Faraday.new(@url) do |f|
      f.request :json
      f.response :json
    end.get

    @addresses = fetch_addresses(response.body, type) || []
  end

  # Return addresses as JSON optional pretty formatted.
  def to_json(pretty: false)
    pretty ? JSON.pretty_generate(@addresses.map(&:to_h)) : JSON.generate(@addresses.map(&:to_h))
  end

  # Return address as multiline comma seperated string.
  def to_s
    @addresses.map(&:to_s).join("\n")
  end

  private

  def fetch_addresses(osm_records, type)
    addresses = osm_records.map do |osm_record|
      address = Rolf::Address.new(osm_record:)
      next if !type.nil? && !address.type?(type)
      next if !address.city?(@terms[:city])

      address
    end

    addresses.uniq do |address|
      address.to_h.keys
    end.compact
  end

  def sanitize_url_param(string)
    string.gsub(/[äöüß]/i) do |match|
      case match.downcase
      when 'ä' then 'ae'
      when 'ö' then 'oe'
      when 'ü' then 'ue'
      when 'ß' then 'ss'
      else match.downcase
      end
    end
  end

  def url_params
    @terms.map do |pair|
      sanitize_url_param(pair.join('=').downcase)
    end.join('&')
  end
end
