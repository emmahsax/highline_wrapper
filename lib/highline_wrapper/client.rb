# frozen_string_literal: true

class HighlineWrapper
  class Client
    def ask(prompt, secret)
      highline.ask(prompt) do |conf|
        conf.readline = true
        if secret
          conf.echo = false
          conf.echo = '*'
        end
      end.to_s
    end

    def ask_yes_no(prompt, preference)
      answer = highline.ask(prompt) do |conf|
        conf.readline = true
      end.to_s

      answer.empty? ? preference : !!(answer =~ /^y/i)
    end

    def ask_multiple_choice(prompt, choices, with_index)
      index = highline.ask(format_options(prompt, choices)) do |conf|
        conf.readline = true
      end.to_i - 1

      if with_index
        { choice: choices[index], index: index }
      else
        choices[index]
      end
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def ask_checkbox(prompt, choices, provide_indices)
      indices = []
      selected = []

      answer = highline.ask(format_options(prompt, choices)) do |conf|
        conf.readline = true
      end

      answer.split(',').each { |i| indices << i.strip.to_i - 1 }

      if provide_indices
        indices.each { |index| selected << { choice: choices[index], index: index } }
      else
        indices.each { |index| selected << choices[index] }
      end

      selected
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    private def format_options(prompt, choices)
      choices_as_string_options = ''.dup
      choices.each_with_index { |choice, index| choices_as_string_options << "#{index + 1}. #{choice}\n" }
      "#{prompt}\n#{choices_as_string_options.strip}"
    end

    private def highline
      @highline ||= HighLine.new
    end
  end
end
