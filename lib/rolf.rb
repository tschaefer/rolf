# frozen_string_literal: true

require 'faraday'

require 'rolf/address'

module Rolf
  BASE_URL  = 'https://names.geo.core.io'
  QUERY_URL = '%s/search.php?countrycode=de&%s&addressdetails=1&format=jsonv2'

  attr_reader :addresses

  class << self
    def new(city:, street:, state: nil)
      @terms = { city:, street:, state: }
      @url = URI(format(
                   QUERY_URL,
                   ENV['ROLF_BASE_URL'] || BASE_URL,
                   url_params
                 ))

      self
    end

    def query(type: nil)
      response = Faraday.new(@url) do |f|
        f.request :json
        f.response :json
      end.get

      @addresses = addresses(response.body, type)
    end

    private

    def addresses(data, type)
      addresses = data.map do |part|
        address = Rolf::Address.new(part)
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
end
