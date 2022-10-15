# frozen_string_literal: true

require 'spec_helper'

require 'rolf'

RSpec.describe Rolf, :aggregate_failures do
  let(:actual) do
    VCR.use_cassette('query', record: :new_episodes) do
      described_class.query(city: city, street: street, state: state) # rubocop:disable Style/HashSyntax
    end
  end
  let(:state) { '' }

  shared_examples 'list' do
    it 'returns address list' do
      expect(actual).to be_an(Array)
      expect(actual.size).to be(1)
      expect(actual).to all(be_a(Struct))
      expect(actual[0].to_h).to eq(expected)
    end
  end

  shared_examples 'empty' do
    it 'returns no address list' do
      expect(actual).to be_an(Array)
      expect(actual.size).to be(0)
      expect(actual[0]).to be_nil
    end
  end

  shared_examples 'error' do
    it 'fails with error' do
      expect { actual }.to raise_error(URI::InvalidURIError)
    end
  end

  describe '#query' do
    context 'with existing city and street' do
      let(:city)   { 'Garmisch-Partenkirchen' }
      let(:street) { 'Zugspitzstrasse' }
      let(:expected) do
        {
          road: 'Zugspitzstraße',
          town: 'Garmisch-Partenkirchen',
          county: 'Landkreis Garmisch-Partenkirchen',
          state_district: 'Obb',
          state: 'Bayern',
          postcode: '82467'
        }
      end

      include_examples 'list'
    end

    context 'with not existing city' do
      let(:city)   { 'Entenhausen' }
      let(:street) { 'Hauptstrasse' }

      include_examples 'empty'
    end

    context 'with existing city and not existing street' do
      let(:city)   { 'Garmisch-Partenkirchen' }
      let(:street) { 'Großglocknerstrasse' }

      include_examples 'empty'
    end

    context 'with existing city, existing street and optional existing state' do
      let(:city)   { 'Frankfurt' }
      let(:street) { 'Kopernikusstrasse' }
      let(:state)  { 'Hessen' }
      let(:expected) do
        {
          city: 'Frankfurt',
          city_district: 'Höchst',
          postcode: '65929',
          road: 'Kopernikusstraße',
          state: 'Hessen',
          state_district: 'Regierungsbezirk Darmstadt',
          suburb: 'Höchst'
        }
      end

      include_examples 'list'
    end

    context 'with existing city name with umlauts' do
      let(:city)   { 'Gemünden' }
      let(:street) { 'Zeilbaum' }
      let(:expected) do
        {
          road: 'Zeilbaum',
          village: 'Gemünden',
          county: 'Rhein-Hunsrück-Kreis',
          state: 'Rheinland-Pfalz',
          postcode: '55490'
        }
      end

      include_examples 'list'
    end

    context 'with existing street name with umlauts' do
      let(:city)   { 'Simmern' }
      let(:street) { 'Gemündener Strasse' }
      let(:expected) do
        {
          road: 'Gemündener Straße',
          city: 'Simmern/Hunsrück',
          county: 'Rhein-Hunsrück-Kreis',
          state: 'Rheinland-Pfalz',
          postcode: '55469'
        }
      end

      include_examples 'list'
    end

    context 'with invalid city name' do
      let(:city)   { 'Garmisch★Partenkirchen' }
      let(:street) { 'Zugspitzstrasse' }

      include_examples 'error'
    end

    context 'with invalid street name' do
      let(:city)   { 'Garmisch-Partenkirchen' }
      let(:street) { 'Zugspitzstrasse★' }

      include_examples 'error'
    end
  end
end
