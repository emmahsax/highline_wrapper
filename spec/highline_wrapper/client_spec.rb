# frozen_string_literal: true

require 'spec_helper'
require 'highline_wrapper'

describe HighlineWrapper::Client do
  let(:response) { double(:response, readline: true, to_i: 3) }
  let(:highline) { double(:highline_cli, ask: response) }

  before do
    allow(HighLine).to receive(:new).and_return(highline)
  end

  describe '#ask' do
    it 'should ask the highline client ask' do
      expect(highline).to receive(:ask)
      subject.ask(Faker::Lorem.sentence, false)
    end

    it 'should return a string' do
      expect(subject.ask(Faker::Lorem.sentence, true)).to be_a(String)
    end
  end

  describe '#ask_yes_no' do
    it 'should ask the highline client ask' do
      expect(highline).to receive(:ask)
      subject.ask_yes_no(Faker::Lorem.sentence, true)
    end

    it 'should return a boolean' do
      expect(subject.ask_yes_no(Faker::Lorem.sentence, false)).to be_falsey
    end

    it 'should return true if we say yes' do
      allow(response).to receive(:to_s).and_return('y')
      expect(subject.ask_yes_no(Faker::Lorem.sentence, false)).to be_truthy
    end

    it 'should return false if we say yes' do
      allow(response).to receive(:to_s).and_return('no')
      expect(subject.ask_yes_no(Faker::Lorem.sentence, true)).to be_falsey
    end

    context 'when preferring true' do
      it 'should return true if empty' do
        allow(response).to receive(:to_s).and_return('')
        expect(subject.ask_yes_no(Faker::Lorem.sentence, true)).to be_truthy
      end

      it 'should return false if empty' do
        allow(response).to receive(:to_s).and_return('')
        expect(subject.ask_yes_no(Faker::Lorem.sentence, false)).to be_falsey
      end
    end
  end

  describe '#ask_multiple_choice' do
    it 'should ask the highline client ask' do
      expect(highline).to receive(:ask)
      subject.ask_multiple_choice(Faker::Lorem.sentence, %w[one two three], false)
    end

    context 'when not including the index' do
      it 'should return an array of one from the options' do
        resp = subject.ask_multiple_choice(Faker::Lorem.sentence, %w[one two three], false)
        expect(resp).to be_a(String)
        expect(resp).to eq('three')
      end
    end

    context 'when including the index' do
      it 'should return an array of two' do
        resp = subject.ask_multiple_choice(Faker::Lorem.sentence, %w[one two three], true)
        expect(resp).to be_a(Hash)
        expect(resp[:choice]).to eq('three')
        expect(resp[:index]).to eq(2)
      end
    end
  end

  describe '#ask_checkbox' do
    it 'should ask the highline client ask' do
      expect(highline).to receive(:ask).and_return('2')
      subject.ask_checkbox(Faker::Lorem.sentence, %w[one two three], false)
    end

    context 'when not including the index' do
      it 'should return an array of one from the options' do
        allow(highline).to receive(:ask).and_return('1, 3')
        resp = subject.ask_checkbox(Faker::Lorem.sentence, %w[one two three], false)
        expect(resp).to be_a(Array)
        expect(resp.count).to eq(2)
        expect(resp).to include('one')
      end
    end

    context 'when including the index' do
      it 'should return an array of two' do
        allow(highline).to receive(:ask).and_return('1, 3')
        resp = subject.ask_checkbox(Faker::Lorem.sentence, %w[one two three], true)
        expect(resp).to be_a(Array)
        expect(resp.count).to eq(2)
        expect(resp).to include({ choice: 'one', index: 0 })
        expect(resp).to include({ choice: 'three', index: 2 })
      end
    end
  end
end
