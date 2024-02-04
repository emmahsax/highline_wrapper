# frozen_string_literal: true

require File.expand_path('lib/highline_wrapper/version.rb', __dir__)

Gem::Specification.new do |gem|
  gem.authors               = ['Emma Sax']
  gem.description           = 'Making it easier to ask simple questions, such as multiple choice ' \
                              'questions, yes/no questions, etc, using HighLine.'
  gem.executables           = Dir['bin/*'].map { |f| File.basename(f) }

  gem.files = Dir['lib/highline_wrapper/*.rb'] + Dir['lib/*.rb'] + Dir['bin/*']
  gem.files += Dir['[A-Z]*'] + Dir['test/**/*']
  gem.files.reject! { |fn| fn.include? '.gem' }

  gem.homepage              = 'https://github.com/emmahsax/highline_wrapper'
  gem.license               = 'BSD-3-Clause'
  gem.metadata              = { 'rubygems_mfa_required' => 'true' }
  gem.name                  = 'highline_wrapper'
  gem.require_paths         = ['lib']
  gem.required_ruby_version = '>= 1.9.3'
  gem.summary               = 'A little HighLine wrapper'
  gem.version               = HighlineWrapper::VERSION

  gem.add_dependency 'highline', '~> 3.0'
  gem.add_dependency 'abbrev', '~> 0.1'

  gem.add_development_dependency 'bundler', '~> 2.2'
  gem.add_development_dependency 'faker', '~> 3.0'
  gem.add_development_dependency 'guard-rspec', '~> 4.3'
  gem.add_development_dependency 'pry', '~> 0.13'
  gem.add_development_dependency 'rspec', '~> 3.9'
  gem.add_development_dependency 'rubocop', '~> 1.10'
end
