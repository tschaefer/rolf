# frozen_string_literal: true

require 'clamp'
require 'pastel'
require 'tty-pager'

require_relative '../version'
require_relative '../../rolf'

class Rolf
  module App
    class BaseCommand < Clamp::Command
      option ['-m', '--man'], :flag, 'show manpage' do
        manpage = <<~MANPAGE
          Name:
              rolf - Ask for postcode.

          #{help}
          Description:
              Ask Rolf with german city, street and optional federal state name and he will answer you with all matching postcodes.

          Authors:
              Tobias Schäfer <github@blackox.org>

          Copyright and License
              This software is copyright (c) 2022 by Tobias Schäfer.

              This package is free software; you can redistribute it and/or modify it under the terms of the "MIT License".
        MANPAGE
        TTY::Pager.page(manpage)

        exit 0
      end

      option ['-v', '--version'], :flag, 'show version' do
        puts "rolf #{Rolf::VERSION}"
        exit 0
      end

      def bailout(message)
        puts Pastel.new.red.bold(message)
        exit 1
      end
    end
  end
end
