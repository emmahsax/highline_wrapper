# frozen_string_literal: true

guard :rspec, cmd: 'bundle exec rspec', all_on_start: true do
  watch('spec/spec_helper.rb') { 'spec' }
  watch(%r{^lib/(.+)\.rb$})    { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/.+_spec\.rb$})
end
