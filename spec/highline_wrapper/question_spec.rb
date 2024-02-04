# frozen_string_literal: true

require 'spec_helper'
require 'highline_wrapper'

describe HighlineWrapper::Question do
  let(:response) { double(:response, to_i: 3) }
  let(:highline) { double(:highline_cli, ask: response) }

  before do
    allow(HighLine).to receive(:new).and_return(highline)
    allow(subject).to receive(:puts)
  end

  after do
    HighlineWrapper::Question.instance_variable_set('@highline', nil)
  end

  subject { HighlineWrapper::Question }

  describe '#highline' do
    it 'should start a new highline client' do
      expect(HighLine).to receive(:new)
      subject.send(:highline)
    end
  end

  describe '#ask_highline' do
    it 'should ask the highline client a question' do
      expect(HighLine).to receive(:new)
      subject.send(:ask_highline, Faker::Lorem.sentence)
    end

    it 'should accept an optional secret parameter' do
      expect(HighLine).to receive(:new)
      subject.send(:ask_highline, Faker::Lorem.sentence, secret: true)
    end
  end

  describe '#format_options' do
    it 'should format the prompt and choices into a single string with new lines' do
      response = "Prompt\n1. Choice 1\n2. Choice 2"
      expect(subject.format_options('Prompt', ['Choice 1', 'Choice 2'])).to eq(response)
    end
  end

  describe '#format_selection' do
    let(:choices) { %w[one two three] }
    let(:index) { 1 }

    context 'with_index as false' do
      it 'should format the selection based on the index into a hash' do
        expect(subject.format_selection(choices, index, false)).to eq({ value: 'two' })
      end
    end

    context 'with_index as true' do
      it 'should format the selection based on the index into a hash' do
        expect(subject.format_selection(choices, index, true)).to eq({ value: 'two', index: 1 })
      end
    end
  end

  describe '#should print out a message indicating EMPTY was selected, and return the defaults' do
    context 'when default message is true' do
      let(:options) do
        {
          defaults: :default,
          indicate_default_message: true
        }
      end

      it 'should return the default in the options' do
        expect(subject.send(:return_empty_defaults, options)).to eq(:default)
      end

      it 'should puts a message' do
        expect(subject).to receive(:puts)
        expect(subject.send(:return_empty_defaults, options)).to eq(:default)
      end
    end

    context 'when default message is false' do
      let(:options) do
        {
          defaults: :default,
          indicate_default_message: false
        }
      end

      it 'should return the default in the options' do
        expect(subject.send(:return_empty_defaults, options)).to eq(:default)
      end

      it 'should not puts a message' do
        expect(subject).not_to receive(:puts)
        expect(subject.send(:return_empty_defaults, options)).to eq(:default)
      end
    end

    context 'when a singular default is present, but not plural' do
      let(:options) do
        {
          default: :default,
          indicate_default_message: false
        }
      end

      it 'should return the default in the options' do
        expect(subject.send(:return_empty_defaults, options)).to eq(:default)
      end
    end
  end
end
