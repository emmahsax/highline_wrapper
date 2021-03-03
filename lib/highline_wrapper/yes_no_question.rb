# frozen_string_literal: true

require_relative 'question'

class HighlineWrapper
  class YesNoQuestion < Question
    class << self
      def ask(prompt, options)
        answer = highline.ask(prompt) do |conf|
          conf.readline = true
        end.to_s

        return !!(answer =~ /^y/i) unless answer.empty?

        if options[:required]
          puts "\nThis question is required.\n\n"
          ask(prompt, options)
        else
          puts
          options[:default]
        end
      end
    end
  end
end
