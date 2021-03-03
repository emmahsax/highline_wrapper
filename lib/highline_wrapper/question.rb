# frozen_string_literal: true

class HighlineWrapper
  class Question
    class << self
      def highline
        @highline = HighLine.new
      end

      def format_options(prompt, choices)
        choices_as_string_options = ''.dup
        choices.each_with_index { |choice, index| choices_as_string_options << "#{index + 1}. #{choice}\n" }
        "#{prompt}\n#{choices_as_string_options.strip}"
      end

      def format_selections(choices, index, with_index)
        response = { value: choices[index] }
        response[:index] = index if with_index
        response
      end
    end
  end
end
