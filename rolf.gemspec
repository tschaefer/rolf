# frozen_string_literal: true

$LOAD_PATH << File.expand_path('lib', __dir__)
require 'rolf/version'

Gem::Specification.new do |spec|
  spec.name        = 'rolf'
  spec.version     = Rolf::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ['Tobias Schäfer']
  spec.email       = ['github@blackox.org']

  spec.summary     = 'Ask Rolf for postcode.'
  spec.description = <<~DESC
    #{spec.summary}

    Ask Rolf with german city, street and optional federal state name
    and he will answer you with all matching postcodes.

  DESC
  spec.homepage    = 'https://github.com/tschaefer/rolf'
  spec.license     = 'MIT'

  spec.files                 = Dir['lib/**/*']
  spec.bindir                = 'bin'
  spec.executables           = ['rolf']
  spec.require_paths         = ['lib']
  spec.required_ruby_version = '>= 3.1'

  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.metadata['source_code_uri']       = 'https://github.com/tschaefer/rolf'
  spec.metadata['bug_tracker_uri']       = 'https://github.com/tschaefer/rolf/issues'
end
