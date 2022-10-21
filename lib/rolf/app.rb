# frozen_string_literal: true

require_relative 'app/base'
require_relative 'app/query'

class Rolf
  module App
    class Command < Rolf::App::BaseCommand
      subcommand 'query', 'query postalcode', Rolf::App::QueryCommand
    end
  end
end
