# frozen_string_literal: true

require_relative 'question'

class HighlineWrapper
  class OpenEndedQuestion < Question
    class << self
      def ask(prompt, options)
        answer = ask_highline(prompt, secret: options[:secret]).to_s

        if (!options[:secret] && (options[:include_newline] || answer.empty?)) ||
           (options[:secret] && (options[:include_newline] && !answer.empty?))
          puts
        end

        return answer unless answer.empty?
        return recurse(prompt, nil, options) if options[:required]

        options[:default]
      end
    end
  end
end
