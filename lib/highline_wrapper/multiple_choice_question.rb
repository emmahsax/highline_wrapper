# frozen_string_literal: true

require_relative 'question'

class HighlineWrapper
  class MultipleChoiceQuestion < Question
    class << self
      def ask(prompt, choices, options)
        index = ask_highline(format_options(prompt, choices)).to_i - 1

        return format_selection(choices, index, options[:with_index]) unless index == -1
        return recurse(prompt, choices, options) if options[:required]
        return return_empty_defaults(options) if options[:default].nil?

        return_defaults(choices, options)
      end

      private def return_defaults(choices, options)
        options[:default_index] = choices.index(options[:default])
        print_default_message(options) if options[:indicate_default_message]
        format_selection(choices, options[:default_index], options[:with_index])
      end

      private def print_default_message(options)
        puts "--- Default selected: #{options[:default_index] + 1}. #{options[:default]} ---"
      end
    end
  end
end
