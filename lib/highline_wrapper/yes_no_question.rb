# frozen_string_literal: true

require_relative 'question'

class HighlineWrapper
  class YesNoQuestion < Question
    class << self
      def ask(prompt, options)
        answer = ask_highline(prompt)

        return !!(answer =~ /^y/i) unless answer.empty?
        return recurse(prompt, nil, options) if options[:required]

        puts
        options[:default]
      end

      private def ask_highline(prompt)
        highline.ask(prompt) do |conf|
          conf.readline = true
        end.to_s
      end
    end
  end
end
