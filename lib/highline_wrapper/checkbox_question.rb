# frozen_string_literal: true

require_relative 'question'

class HighlineWrapper
  class CheckboxQuestion < Question
    class << self
      def ask(prompt, choices, options)
        indices = ask_highline(format_options(prompt, choices))

        return format_multiple_selections(choices, indices, options[:with_indexes]) unless indices.empty?
        return recurse(prompt, choices, options) if options[:required]
        return return_empty_defaults(options) if options[:defaults].empty?

        return_defaults(choices, options)
      end

      private def ask_highline(prompt)
        indices = []
        super(prompt).to_s.split(',').each { |i| indices << i.strip.to_i - 1 }
        indices
      end

      private def return_defaults(choices, options)
        options[:default_indexes] = options[:defaults].map { |d| choices.index(d) }
        print_default_message(options, choices) if options[:indicate_default_message]
        format_multiple_selections(choices, options[:default_indexes], options[:with_indexes])
      end

      private def print_default_message(options, choices)
        defaults = options[:default_indexes].map { |i| "#{i + 1}. #{choices[i]}".strip }.join(', ')
        puts "--- Defaults selected: #{defaults} ---"
      end

      private def format_multiple_selections(choices, indices, with_indexes)
        selected = []
        indices.each { |index| selected << format_selection(choices, index, with_indexes) }
        selected
      end
    end
  end
end
