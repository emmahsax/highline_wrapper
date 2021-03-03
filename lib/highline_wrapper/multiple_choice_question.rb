# frozen_string_literal: true

require_relative 'question'

class HighlineWrapper
  class MultipleChoiceQuestion < Question
    class << self
      def ask(prompt, choices, options)
        index = ask_highline(prompt, choices)

        return format_selection(choices, index, options[:with_index]) unless index == -1
        return recurse(prompt, choices, options) if options[:required]

        puts

        return nil if options[:default].nil?

        format_selection(choices, choices.index(options[:default]), options[:with_index])
      end

      private def ask_highline(prompt, choices)
        highline.ask(format_options(prompt, choices)) do |conf|
          conf.readline = true
        end.to_i - 1
      end
    end
  end
end
