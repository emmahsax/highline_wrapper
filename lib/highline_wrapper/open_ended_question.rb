# frozen_string_literal: true

require_relative 'question'

class HighlineWrapper
  class OpenEndedQuestion < Question
    class << self
      def ask(prompt, options)
        answer = ask_highline(prompt, secret: options[:secret]).to_s

        return answer unless answer.empty?
        return recurse(prompt, nil, options) if options[:required]

        print_default_message(options) if options[:indicate_default_message]
        options[:default]
      end

      private def print_default_message(options)
        if !options[:secret]
          puts "--- Default selected: #{options[:default].empty? ? 'EMPTY' : options[:default]} ---"
        elsif options[:secret]
          puts '--- Default selected: HIDDEN ---'
        end
      end
    end
  end
end
