# frozen_string_literal: true

require_relative 'question'

class HighlineWrapper
  class OpenEndedQuestion < Question
    class << self
      def ask(prompt, options)
        answer = ask_highline(prompt)

        return answer unless answer.empty?

        if options[:required]
          puts "#{options[:secret] ? '' : "\n"}This question is required.\n\n"
          ask(prompt, options)
        else
          puts
          ''
        end
      end

      private def ask_highline(prompt)
        highline.ask(prompt) do |conf|
          conf.readline = true
          if options[:secret]
            conf.echo = false
            conf.echo = '*'
          end
        end.to_s
      end
    end
  end
end
