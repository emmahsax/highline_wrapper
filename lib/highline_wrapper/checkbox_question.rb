# frozen_string_literal: true

require_relative 'question'

class HighlineWrapper
  class CheckboxQuestion < Question
    class << self
      def ask(prompt, choices, options)
        indices = ask_highline(format_options(prompt, choices))

        return format_multiple_selections(choices, indices, options[:with_indexes]) unless indices.empty?
        return recurse(prompt, choices, options) if options[:required]

        puts

        return options[:defaults] if options[:defaults].empty?

        format_multiple_selections(choices, options[:defaults].map { |d| choices.index(d) }, options[:with_indexes])
      end

      private def ask_highline(prompt)
        indices = []
        super(prompt).to_s.split(',').each { |i| indices << i.strip.to_i - 1 }
        indices
      end

      private def format_multiple_selections(choices, indices, with_indexes)
        selected = []
        indices.each { |index| selected << format_selection(choices, index, with_indexes) }
        selected
      end
    end
  end
end
