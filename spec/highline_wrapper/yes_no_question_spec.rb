# frozen_string_literal: true

require 'spec_helper'
require 'highline_wrapper'

describe HighlineWrapper::YesNoQuestion do
  let(:response) { double(:response, readline: true, to_i: 3) }
  let(:highline) { double(:highline_cli, ask: response) }

  before do
    allow(HighLine).to receive(:new).and_return(highline)
    allow(subject).to receive(:puts)
  end

  after do
    HighlineWrapper::YesNoQuestion.instance_variable_set('@highline', nil)
  end

  subject { HighlineWrapper::YesNoQuestion }

  context 'with the options as defaults' do
    let(:options) do
      {
        indicate_default_message: true,
        default: true,
        required: false
      }
    end

    it 'should ask the highline client ask' do
      expect(highline).to receive(:ask).and_return('Y')
      subject.ask(Faker::Lorem.sentence, options)
    end

    it 'should return the value the user selects' do
      allow(highline).to receive(:ask).and_return('n')
      resp = subject.ask(Faker::Lorem.sentence, options)
      expect(resp).to eq(false)
    end

    it 'should return true if the user skips' do
      allow(highline).to receive(:ask).and_return('')
      resp = subject.ask(Faker::Lorem.sentence, options)
      expect(resp).to eq(true)
    end

    it 'should call to print the default message' do
      allow(highline).to receive(:ask).and_return('')
      expect(subject).to receive(:print_default_message)
      subject.ask(Faker::Lorem.sentence, options)
    end

    it 'should recurse if the answer given is unparseable' do
      allow(highline).to receive(:ask).and_return('yep', 'yessss', 'yes')
      expect(subject).to receive(:recurse).exactly(2).times.and_call_original
      subject.ask(Faker::Lorem.sentence, options)
    end
  end

  context 'with required set to true' do
    let(:options) do
      {
        default: false,
        required: true
      }
    end

    it 'should return the value the user selects' do
      allow(highline).to receive(:ask).and_return('y')
      resp = subject.ask(Faker::Lorem.sentence, options)
      expect(resp).to eq(true)
    end

    it 'should recurse multiple times if the user skips' do
      allow(highline).to receive(:ask).and_return('', '', 'y')
      expect(subject).to receive(:ask).exactly(3).times.and_call_original
      subject.ask(Faker::Lorem.sentence, options)
    end
  end

  context 'with required set to false' do
    let(:options) do
      {
        indicate_default_message: false,
        default: false,
        required: false
      }
    end

    it 'should return the value the user selects' do
      allow(highline).to receive(:ask).and_return('y')
      resp = subject.ask(Faker::Lorem.sentence, options)
      expect(resp).to eq(true)
    end

    it 'should return the default if the user skips' do
      allow(highline).to receive(:ask).and_return('')
      resp = subject.ask(Faker::Lorem.sentence, options)
      expect(resp).to eq(false)
    end

    it 'should not call to print the default message' do
      allow(highline).to receive(:ask).and_return('')
      expect(subject).not_to receive(:print_default_message)
      subject.ask(Faker::Lorem.sentence, options)
    end
  end
end
