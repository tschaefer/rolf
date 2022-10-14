# frozen_string_literal: true

require 'faraday'

module Rolf
  BASE_URL  = 'https://names.geo.core.io'
  QUERY_URL = '%s/search.php?countrycode=de&%s&addressdetails=1&format=jsonv2'

  class << self
    def query(city:, street:, state: nil)
      @keywords = { city:, street:, state: }

      url = URI(format(QUERY_URL, ENV['ROLF_NOMINATIM_BASE_URL'] || BASE_URL, keywords))

      response = Faraday.new(url) do |f|
        f.request :json
        f.response :json
      end.get

      list(response.body)
    end

    private

    def keywords
      @keywords.map { |pair| umlauts(pair.join('=')) }.join('&')
    end

    def list(data)
      data.map do |part|
        address = part['address'].except('country', 'country_code', 'continent')
        address = address.transform_keys(&:to_sym)
        next if !valid?(address)

        address
      end.uniq.compact
    end

    def umlauts(string)
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

    def valid?(address)
      return false if !address.keys.first.eql?(:road)

      %i[city village town].each do |place|
        return true if address.key?(place) &&
                       address[place].downcase.match(/#{@keywords[:city].downcase}/)
      end

      false
    end
  end
end
