# frozen_string_literal: true

require 'spec_helper'
require 'highline_wrapper'

describe HighlineWrapper do
  let(:choices) { %w[one two three] }
  let(:response) { Faker::Lorem.word }
  let(:highline_client) do
    double(:highline_cli,
           ask: response,
           ask_yes_no: true,
           ask_multiple_choice: [response])
  end

  before do
    allow(HighlineWrapper::Client).to receive(:new).and_return(highline_client)
  end

  describe '#ask' do
    it 'should ask the highline client' do
      expect(highline_client).to receive(:ask)
      subject.ask(Faker::Lorem.sentence)
    end

    it 'should return a string' do
      expect(subject.ask(Faker::Lorem.sentence)).to be_a(String)
    end

    it 'should ask the highline client' do
      expect(highline_client).to receive(:ask)
      subject.ask(Faker::Lorem.sentence, {})
    end
  end

  describe '#ask_yes_no' do
    it 'should ask the highline client' do
      expect(highline_client).to receive(:ask_yes_no)
      subject.ask_yes_no(Faker::Lorem.sentence)
    end

    it 'should return a boolean' do
      allow(highline_client).to receive(:ask_yes_no).and_return(false)
      expect(subject.ask_yes_no(Faker::Lorem.sentence)).to be_falsey
    end

    it 'should accept an optional hash' do
      allow(highline_client).to receive(:ask_yes_no).and_return(false)
      expect(subject.ask_yes_no(Faker::Lorem.sentence, {})).to be_falsey
    end
  end

  describe '#ask_multiple_choice' do
    it 'should ask the highline client ask' do
      expect(highline_client).to receive(:ask_multiple_choice)
      subject.ask_multiple_choice(Faker::Lorem.sentence, choices)
    end

    it 'should return a string from the options' do
      allow(highline_client).to receive(:ask_multiple_choice).and_return('one')
      resp = subject.ask_multiple_choice(Faker::Lorem.sentence, choices)
      expect(resp).to be_a(String)
    end

    context 'when we ask for an index in the options' do
      it 'should return a string AND an integer index' do
        allow(highline_client).to receive(:ask_multiple_choice).and_return({ choice: 'one', index: 0 })
        resp = subject.ask_multiple_choice(Faker::Lorem.sentence, choices, { with_index: true })
        expect(resp[:choice]).to eq('one')
        expect(resp[:index]).to eq(0)
      end
    end
  end

  describe '#ask_checkbox' do
    it 'should ask the highline client ask' do
      expect(highline_client).to receive(:ask_checkbox)
      subject.ask_checkbox(Faker::Lorem.sentence, choices)
    end

    it 'should return a string from the options' do
      allow(highline_client).to receive(:ask_checkbox).and_return(%w[one three])
      resp = subject.ask_checkbox(Faker::Lorem.sentence, choices)
      expect(resp).to be_a(Array)
      expect(resp).to include('one')
      expect(resp).to include('three')
    end

    context 'when we ask for an index in the options' do
      it 'should return a string AND an integer index' do
        allow(highline_client).to receive(:ask_checkbox).and_return([{ choice: 'one', index: 0 }, { choice: 'three', index: 2 }])
        resp = subject.ask_checkbox(Faker::Lorem.sentence, choices, { with_indexes: true })
        expect(resp).to include({ choice: 'one', index: 0 })
        expect(resp.last[:choice]).to eq('three')
      end
    end
  end
end
