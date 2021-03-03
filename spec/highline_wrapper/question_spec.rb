# frozen_string_literal: true

require 'spec_helper'
require 'highline_wrapper'

describe HighlineWrapper::Question do
  let(:response) { double(:response, readline: true, to_i: 3) }
  let(:highline) { double(:highline_cli, ask: response) }

  before do
    allow(HighLine).to receive(:new).and_return(highline)
    allow(subject).to receive(:puts)
  end

  subject { HighlineWrapper::Question }

  describe '#highline' do
    it 'should start a new highline client' do
      expect(HighLine).to receive(:new)
      subject.highline
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
end
