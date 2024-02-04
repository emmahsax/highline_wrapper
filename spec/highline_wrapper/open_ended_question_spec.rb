# frozen_string_literal: true

require 'spec_helper'
require 'highline_wrapper'

describe HighlineWrapper::OpenEndedQuestion do
  let(:response) { double(:response, to_i: 3) }
  let(:highline) { double(:highline_cli, ask: response) }

  before do
    allow(HighLine).to receive(:new).and_return(highline)
    allow(subject).to receive(:puts)
  end

  after do
    HighlineWrapper::OpenEndedQuestion.instance_variable_set('@highline', nil)
  end

  subject { HighlineWrapper::OpenEndedQuestion }

  context 'with the options as defaults' do
    let(:options) do
      {
        indicate_default_message: true,
        secret: false,
        default: '',
        required: false
      }
    end

    it 'should ask the highline client ask' do
      expect(highline).to receive(:ask)
      subject.ask(Faker::Lorem.sentence, options)
    end

    it 'should return the value the user selects' do
      answer = Faker::Lorem.sentence
      allow(highline).to receive(:ask).and_return(answer)
      resp = subject.ask(Faker::Lorem.sentence, options)
      expect(resp).to eq(answer)
    end

    it 'should return empty string if the user skips' do
      allow(highline).to receive(:ask).and_return('')
      resp = subject.ask(Faker::Lorem.sentence, options)
      expect(resp).to eq('')
    end

    it 'should call to print the default message' do
      allow(highline).to receive(:ask).and_return('')
      expect(subject).to receive(:print_default_message)
      subject.ask(Faker::Lorem.sentence, options)
    end
  end

  context 'with required set to true' do
    let(:options) do
      {
        secret: false,
        default: 'something-goes-here',
        required: true
      }
    end

    it 'should return the value the user selects' do
      answer = Faker::Lorem.sentence
      allow(highline).to receive(:ask).and_return(answer)
      resp = subject.ask(Faker::Lorem.sentence, options)
      expect(resp).to eq(answer)
    end

    it 'should recurse multiple times if the user skips' do
      allow(highline).to receive(:ask).and_return('', '', Faker::Lorem.sentence)
      expect(subject).to receive(:ask).exactly(3).times.and_call_original
      subject.ask(Faker::Lorem.sentence, options)
    end
  end

  context 'with the default set and the required set to false' do
    let(:default_string) { Faker::Lorem.sentence }
    let(:options) do
      {
        indicate_default_message: false,
        secret: false,
        default: default_string,
        required: false
      }
    end

    it 'should return the value the user selects' do
      answer = Faker::Lorem.sentence
      allow(highline).to receive(:ask).and_return(answer)
      resp = subject.ask(Faker::Lorem.sentence, options)
      expect(resp).to eq(answer)
    end

    it 'should return the default value the user skips' do
      allow(highline).to receive(:ask).and_return('')
      expect(subject.ask(Faker::Lorem.sentence, options)).to eq(default_string)
    end

    it 'should not call to print the default message' do
      allow(highline).to receive(:ask).and_return('')
      expect(subject).not_to receive(:print_default_message)
      subject.ask(Faker::Lorem.sentence, options)
    end
  end
end
