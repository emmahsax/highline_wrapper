# frozen_string_literal: true

require 'highline'

files = "#{File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), 'highline_wrapper'))}/**/*.rb"

Dir[files].each do |file|
  require_relative file
end

class HighlineWrapper
  # Returns - string; the answer to the question
  # prompt - string; the prompt for the question
  def ask(prompt, secret: false)
    client.ask(prompt, secret)
  end

  # Returns - boolean; yes for true, no for false
  # prompt - string; the prompt for the question
  # preference - boolean; whether skipping the question should return true or false
  def ask_yes_no(prompt, preference: true)
    client.ask_yes_no(prompt, preference)
  end

  # Returns - string OR hash; the selection
  #   e.g. 'c'
  # prompt - string; the prompt for the question
  # choices - array; an array of string options
  #   e.g. [ 'a', 'b', 'c' ]
  # with_index - boolean; whether to return the index of the selection
  #   e.g. { choice: 'c', index: 2 }
  def ask_multiple_choice(prompt, choices, with_index: false)
    client.ask_multiple_choice(prompt, choices, with_index)
  end

  # Returns - array; an array of selections
  #   e.g. [ 'a', 'c' ]
  # prompt - string; the prompt for the question
  # choices - array; an array of string options
  #   e.g. [ 'a', 'b', 'c' ]
  # with_indexes - boolean; whether to return the indices of the selections
  #   e.g. [ { choice: 'a', index: 0 }, { choice: 'c', index: 2 } ]
  def ask_checkbox(prompt, choices, with_indexes: false)
    client.ask_checkbox(prompt, choices, with_indexes)
  end

  private def client
    @client ||= HighlineWrapper::Client.new
  end
end
