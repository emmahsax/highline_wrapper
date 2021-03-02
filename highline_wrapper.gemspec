# frozen_string_literal: true

require File.expand_path('lib/highline_wrapper/version.rb', __dir__)

Gem::Specification.new do |gem|
  gem.name                  = 'highline_wrapper'
  gem.version               = HighlineWrapper::VERSION
  gem.authors               = ['Emma Sax']
  gem.summary               = 'A little wrapper for Highline'
  gem.description           = 'Making it easier to ask simple questions, such as multiple choice ' \
                              'questions, yes/no questions, etc, using Highline'
  gem.homepage              = 'https://github.com/emmahsax/highline_wrapper'
  gem.license               = 'MIT'
  gem.required_ruby_version = '>= 1.9.3'

  gem.executables   = Dir['bin/*'].map { |f| File.basename(f) }
  gem.files         = Dir['lib/highline_wrapper/*.rb'] + Dir['lib/*.rb'] + Dir['bin/*']
  gem.files += Dir['[A-Z]*'] + Dir['test/**/*']
  gem.files.reject! { |fn| fn.include? '.gem' }
  gem.test_files    = Dir['spec/spec_helper.rb'] + Dir['spec/highline_wrapper/*.rb']
  gem.require_paths = ['lib']

  gem.add_dependency 'highline', '~> 2.0'

  gem.add_development_dependency 'bundler', '~> 2.2'
  gem.add_development_dependency 'faker', '~> 2.15'
  gem.add_development_dependency 'guard-rspec', '~> 4.3'
  gem.add_development_dependency 'pry', '~> 0.13'
  gem.add_development_dependency 'rake', '~> 13.0'
  gem.add_development_dependency 'rspec', '~> 3.9'
  gem.add_development_dependency 'rubocop'
end
