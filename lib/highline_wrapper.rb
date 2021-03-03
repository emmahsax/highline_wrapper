# frozen_string_literal: true

require 'highline'

files = "#{File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), 'highline_wrapper'))}/**/*.rb"

Dir[files].each do |file|
  require_relative file
end

class HighlineWrapper
  OPEN_ENDED_DEFAULTS = {
    secret: false,
    required: false
  }.freeze
  YES_NO_DEFAULTS = {
    default: true,
    required: false
  }.freeze
  MULTIPLE_CHOICE_DEFAULTS = {
    with_index: false,
    default: nil,
    required: false
  }.freeze
  CHECKBOX_DEFAULTS = {
    with_indexes: false,
    defaults: [],
    required: false
  }.freeze

  # Returns: the answer to the question (string)
  #
  # prompt: the prompt for the question (string)
  # options: various options to pass to the questions (hash)
  #   secret: whether the terminal should hide the typed value (boolean - defaults to false)
  #   required: whether the question is required or not (boolean - defaults to false)
  #
  # Notes:
  #  If required == true, the question will repeat until the user answers the question
  def ask(prompt, options = {})
    options = OPEN_ENDED_DEFAULTS.merge(options)
    HighlineWrapper::OpenEndedQuestion.ask(prompt, options)
  end

  # Returns: yes for true, no for false (boolean)
  #
  # prompt: the prompt for the question (string)
  # options: various options to pass to the questions (hash)
  #   default: the default selection (boolean - defaults to true)
  #   required: whether the question is required or not (boolean - defaults to false)
  #
  # Notes:
  #  If required == true, the question will repeat until the user answers the question
  #  If required == true, then the default value will be ignored
  def ask_yes_no(prompt, options = {})
    options = YES_NO_DEFAULTS.merge(options)
    HighlineWrapper::YesNoQuestion.ask(prompt, options)
  end

  # Returns: the selection in a hash (hash)
  #   e.g. { value: 'c' }
  #   e.g. { value: 'c', index: 2 }
  #
  # prompt: the prompt for the question (string)
  # choices: a list of string options (array) (e.g. [ 'a', 'b', 'c' ])
  # options: various options to pass to the questions (hash)
  #   with_index: whether to return the index of the selection (boolean - defaults to false)
  #   default: the default selection if the user skips the question (string - defaults to nil)
  #   required: whether the question is required or not (boolean - defaults to false)
  #
  # Notes:
  #   If required == true, the question will repeat until the user answers the question
  #   If required == true, then the default value will be ignored
  #   If default == nil and required == false, and the user skips the question, the answer will be nil
  def ask_multiple_choice(prompt, choices, options = {})
    options = MULTIPLE_CHOICE_DEFAULTS.merge(options)
    HighlineWrapper::MultipleChoiceQuestion.ask(prompt, choices, options)
  end

  # Returns: the selections chosen as an array of hashes (array)
  #   e.g. [{ value: 'a' }, { value: 'c' }]
  #   e.g. [{ value: 'a', index: 0 }, { value: 'c', index: 2 }])
  #
  # prompt: the prompt for the question (string)
  # choices: a list of string options (array) (e.g. [ 'a', 'b', 'c' ])
  # options: various options to pass to the questions (hash)
  #   with_indexes: whether to return the indexes of the selections (boolean - defaults to false)
  #   defaults: the default selections if the user skips the question (array - defaults to [])
  #   required: whether the question is required or not (boolean - defaults to false)
  #
  # Notes:
  #   If required == true, the question will repeat until the user answers the question
  #   If required == true, then the defaults value will be ignored
  #   If defaults == [] and required == false, then the method will return an empty array
  def ask_checkbox(prompt, choices, options = {})
    options = CHECKBOX_DEFAULTS.merge(options)
    HighlineWrapper::CheckboxQuestion.ask(prompt, choices, options)
  end
end
