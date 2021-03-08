# frozen_string_literal: true

require_relative 'question'

class HighlineWrapper
  class MultipleChoiceQuestion < Question
    class << self
      def ask(prompt, choices, options)
        index = ask_highline(format_options(prompt, choices)).to_i - 1
        puts if options[:include_newline]

        return format_selection(choices, index, options[:with_index]) unless index == -1
        return recurse(prompt, choices, options) if options[:required]
        return nil if options[:default].nil?

        format_selection(choices, choices.index(options[:default]), options[:with_index])
      end
    end
  end
end
