# frozen_string_literal: true

require_relative 'question'

class HighlineWrapper
  class YesNoQuestion < Question
    class << self
      def ask(prompt, options)
        answer = ask_highline(prompt).to_s.downcase
        puts if options[:include_newline] || answer.empty?

        return parse(answer, prompt, options) unless answer.empty?
        return recurse(prompt, nil, options) if options[:required]

        options[:default]
      end

      def parse(answer, prompt, options)
        return true if answer.include?('y')
        return false if answer.include?('n')

        recurse(prompt, nil, options)
      end
    end
  end
end
