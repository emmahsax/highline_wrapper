# frozen_string_literal: true

require_relative 'question'

class HighlineWrapper
  class YesNoQuestion < Question
    class << self
      def ask(prompt, options)
        answer = ask_highline(prompt).to_s.downcase

        return parse(answer, prompt, options) unless answer.empty?
        return recurse(prompt, nil, options) if options[:required]

        print_default_message(options) if options[:indicate_default_message]
        options[:default]
      end

      private def parse(answer, prompt, options)
        return true if answer.length == 3 && answer.include?('yes')
        return false if answer.length == 2 && answer.include?('no')
        return true if answer.length == 1 && answer.include?('y')
        return false if answer.length == 1 && answer.include?('n')

        recurse(prompt, nil, options)
      end

      private def print_default_message(options)
        puts "--- Default selected: #{options[:default] ? 'YES' : 'NO'} ---"
      end
    end
  end
end
