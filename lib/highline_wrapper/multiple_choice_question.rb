# frozen_string_literal: true

require_relative 'question'

class HighlineWrapper
  class MultipleChoiceQuestion < Question
    class << self
      # rubocop:disable Metrics/AbcSize
      def ask(prompt, choices, options)
        index = highline.ask(format_options(prompt, choices)) do |conf|
          conf.readline = true
        end.to_i - 1

        return format_selections(choices, index, options[:with_index]) unless index == -1

        if options[:required]
          puts "\nThis question is required.\n\n"
          ask(prompt, choices, options)
        else
          puts

          return nil if options[:default].nil?

          format_selections(choices, choices.index(options[:default]), options[:with_index])
        end
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
