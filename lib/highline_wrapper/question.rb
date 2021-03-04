# frozen_string_literal: true

class HighlineWrapper
  class Question
    class << self
      def ask_highline(prompt, secret: false)
        highline.ask(prompt) do |conf|
          conf.readline = true
          conf.echo = '*' if secret
        end
      end

      def format_options(prompt, choices)
        choices_as_string_options = ''.dup
        choices.each_with_index { |choice, index| choices_as_string_options << "#{index + 1}. #{choice}\n" }
        "#{prompt}\n#{choices_as_string_options.strip}"
      end

      def format_selection(choices, index, with_index)
        response = { value: choices[index] }
        response[:index] = index if with_index
        response
      end

      def recurse(prompt, choices, options)
        puts "This question is required.\n\n"
        choices.nil? ? ask(prompt, options) : ask(prompt, choices, options)
      end

      private def highline
        @highline ||= HighLine.new
      end
    end
  end
end
