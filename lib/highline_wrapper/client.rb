# frozen_string_literal: true

class HighlineWrapper
  class Client
    def ask(prompt, options)
      answer = highline.ask(prompt) do |conf|
        conf.readline = true
        if options[:secret]
          conf.echo = false
          conf.echo = '*'
        end
      end.to_s

      return answer unless answer.empty?

      if options[:required]
        puts "#{options[:secret] ? '' : "\n"}This question is required.\n\n"
        ask(prompt, options)
      else
        puts
        ''
      end
    end

    def ask_yes_no(prompt, options)
      answer = highline.ask(prompt) do |conf|
        conf.readline = true
      end.to_s

      return !!(answer =~ /^y/i) unless answer.empty?

      if options[:required]
        puts "\nThis question is required.\n\n"
        ask_yes_no(prompt, options)
      else
        puts
        options[:default]
      end
    end

    # rubocop:disable Metrics/AbcSize
    def ask_multiple_choice(prompt, choices, options)
      index = highline.ask(format_options(prompt, choices)) do |conf|
        conf.readline = true
      end.to_i - 1

      return determine_multiple_choice_selection(choices, index, options[:with_index]) unless index == -1

      if options[:required]
        puts "\nThis question is required.\n\n"
        ask_multiple_choice(prompt, choices, options)
      else
        puts

        return nil if options[:default].nil?

        determine_multiple_choice_selection(choices, choices.index(options[:default]), options[:with_index])
      end
    end
    # rubocop:enable Metrics/AbcSize

    # rubocop:disable Metrics/AbcSize
    def ask_checkbox(prompt, choices, options)
      indices = []

      answer = highline.ask(format_options(prompt, choices)) do |conf|
        conf.readline = true
      end.to_s

      answer.split(',').each { |i| indices << i.strip.to_i - 1 }

      return determine_checkbox_selections(choices, indices, options[:with_indexes]) unless indices.empty?

      if options[:required]
        puts "\nThis question is required.\n\n"
        ask_checkbox(prompt, choices, options)
      else
        puts

        return options[:defaults] if options[:defaults].empty?

        indices = options[:defaults].map { |d| choices.index(d) }
        determine_checkbox_selections(choices, indices, options[:with_indexes])
      end
    end
    # rubocop:enable Metrics/AbcSize

    private def determine_multiple_choice_selection(choices, index, with_index)
      response = { value: choices[index] }
      response[:index] = index if with_index
      response
    end

    private def determine_checkbox_selections(choices, indices, with_indexes)
      selected = []

      indices.each do |index|
        response = { value: choices[index] }
        response[:index] = index if with_indexes
        selected << response
      end

      selected
    end

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
