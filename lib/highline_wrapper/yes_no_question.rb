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
        case answer
        when 'yes', 'y'
          true
        when 'no', 'n'
          false
        else
          recurse(prompt, nil, options)
        end
      end

      private def print_default_message(options)
        puts "--- Default selected: #{options[:default] ? 'YES' : 'NO'} ---"
      end
    end
  end
end
