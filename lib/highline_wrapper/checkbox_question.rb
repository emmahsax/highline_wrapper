# frozen_string_literal: true

require_relative 'question'

class HighlineWrapper
  class CheckboxQuestion < Question
    class << self
      # rubocop:disable Metrics/AbcSize
      def ask(prompt, choices, options)
        indices = []

        answer = highline.ask(format_options(prompt, choices)) do |conf|
          conf.readline = true
        end.to_s

        answer.split(',').each { |i| indices << i.strip.to_i - 1 }

        return determine_checkbox_selections(choices, indices, options[:with_indexes]) unless indices.empty?

        if options[:required]
          puts "\nThis question is required.\n\n"
          ask(prompt, choices, options)
        else
          puts

          return options[:defaults] if options[:defaults].empty?

          indices = options[:defaults].map { |d| choices.index(d) }
          determine_checkbox_selections(choices, indices, options[:with_indexes])
        end
      end
      # rubocop:enable Metrics/AbcSize

      private def determine_checkbox_selections(choices, indices, with_indexes)
        selected = []
        indices.each { |index| selected << format_selections(choices, index, with_indexes) }
        selected
      end
    end
  end
end
