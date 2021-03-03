# frozen_string_literal: true

require_relative 'question'

class HighlineWrapper
  class YesNoQuestion < Question
    class << self
      def ask(prompt, options)
        answer = ask_highline(prompt).to_s

        return !!(answer =~ /^y/i) unless answer.empty?
        return recurse(prompt, nil, options) if options[:required]

        puts
        options[:default]
      end
    end
  end
end
