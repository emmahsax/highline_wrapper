# frozen_string_literal: true

require_relative 'question'

class HighlineWrapper
  class OpenEndedQuestion < Question
    class << self
      def ask(prompt, options)
        answer = ask_highline(prompt, options)

        return answer unless answer.empty?
        return recurse(prompt, nil, options) if options[:required]

        puts
        ''
      end

      private def ask_highline(prompt, options)
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
