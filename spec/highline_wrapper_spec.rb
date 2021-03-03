# frozen_string_literal: true

require 'spec_helper'
require 'highline_wrapper'

describe HighlineWrapper do
  let(:choices) { %w[one two three] }
  let(:response) { Faker::Lorem.word }

  describe '#ask' do
    before do
      allow(HighlineWrapper::OpenEndedQuestion).to receive(:ask)
    end

    it 'should ask the highline client' do
      expect(HighlineWrapper::OpenEndedQuestion).to receive(:ask)
      subject.ask(Faker::Lorem.sentence)
    end

    it 'should return a string' do
      allow(HighlineWrapper::OpenEndedQuestion).to receive(:ask).and_return(response)
      expect(subject.ask(Faker::Lorem.sentence)).to be_a(String)
    end

    it 'should ask the highline client' do
      expect(HighlineWrapper::OpenEndedQuestion).to receive(:ask)
      subject.ask(Faker::Lorem.sentence, {})
    end
  end

  describe '#ask_yes_no' do
    before do
      allow(HighlineWrapper::YesNoQuestion).to receive(:ask)
    end

    it 'should ask the highline client' do
      expect(HighlineWrapper::YesNoQuestion).to receive(:ask)
      subject.ask_yes_no(Faker::Lorem.sentence)
    end

    it 'should return a boolean' do
      allow(HighlineWrapper::YesNoQuestion).to receive(:ask).and_return(false)
      expect(subject.ask_yes_no(Faker::Lorem.sentence)).to be_falsey
    end

    it 'should accept an optional hash' do
      allow(HighlineWrapper::YesNoQuestion).to receive(:ask).and_return(false)
      expect(subject.ask_yes_no(Faker::Lorem.sentence, {})).to be_falsey
    end
  end

  describe '#ask_multiple_choice' do
    before do
      allow(HighlineWrapper::MultipleChoiceQuestion).to receive(:ask)
    end

    it 'should ask the highline client ask' do
      expect(HighlineWrapper::MultipleChoiceQuestion).to receive(:ask)
      subject.ask_multiple_choice(Faker::Lorem.sentence, choices)
    end

    it 'should return a string from the options' do
      allow(HighlineWrapper::MultipleChoiceQuestion).to receive(:ask).and_return('one')
      resp = subject.ask_multiple_choice(Faker::Lorem.sentence, choices)
      expect(resp).to be_a(String)
    end

    context 'when we ask for an index in the options' do
      it 'should return a string AND an integer index' do
        allow(HighlineWrapper::MultipleChoiceQuestion).to receive(:ask).and_return({ value: 'one', index: 0 })
        resp = subject.ask_multiple_choice(Faker::Lorem.sentence, choices, { with_index: true })
        expect(resp[:value]).to eq('one')
        expect(resp[:index]).to eq(0)
      end
    end
  end

  describe '#ask_checkbox' do
    before do
      allow(HighlineWrapper::CheckboxQuestion).to receive(:ask)
    end

    it 'should ask the highline client ask' do
      expect(HighlineWrapper::CheckboxQuestion).to receive(:ask)
      subject.ask_checkbox(Faker::Lorem.sentence, choices)
    end

    it 'should return a string from the options' do
      allow(HighlineWrapper::CheckboxQuestion).to receive(:ask).and_return(%w[one three])
      resp = subject.ask_checkbox(Faker::Lorem.sentence, choices)
      expect(resp).to be_a(Array)
      expect(resp).to include('one')
      expect(resp).to include('three')
    end

    context 'when we ask for an index in the options' do
      it 'should return a string AND an integer index' do
        allow(HighlineWrapper::CheckboxQuestion).to receive(:ask).and_return([{ value: 'one', index: 0 }, { value: 'three', index: 2 }])
        resp = subject.ask_checkbox(Faker::Lorem.sentence, choices, { with_indexes: true })
        expect(resp).to include({ value: 'one', index: 0 })
        expect(resp.last[:value]).to eq('three')
      end
    end
  end
end
