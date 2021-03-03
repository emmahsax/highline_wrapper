# frozen_string_literal: true

require 'spec_helper'
require 'highline_wrapper'

describe HighlineWrapper::MultipleChoiceQuestion do
  let(:choices) { %w[one two three] }
  let(:response) { double(:response, readline: true, to_i: 3) }
  let(:highline) { double(:highline_cli, ask: response) }

  before do
    allow(HighLine).to receive(:new).and_return(highline)
    allow(subject).to receive(:puts)
  end

  after do
    HighlineWrapper::MultipleChoiceQuestion.instance_variable_set('@highline', nil)
  end

  subject { HighlineWrapper::MultipleChoiceQuestion }

  context 'with the options as defaults' do
    let(:options) do
      {
        with_index: false,
        default: nil,
        required: false
      }
    end

    it 'should ask the highline client ask' do
      expect(highline).to receive(:ask)
      subject.ask(Faker::Lorem.sentence, choices, options)
    end

    it 'should return the value the user selects' do
      allow(highline).to receive(:ask).and_return(1)
      resp = subject.ask(Faker::Lorem.sentence, choices, options)
      expect(resp).to eq({ value: 'one' })
    end

    it 'should return nil if the user skips' do
      allow(highline).to receive(:ask).and_return(0)
      resp = subject.ask(Faker::Lorem.sentence, choices, options)
      expect(resp).to eq(nil)
    end
  end

  context 'with required set to true' do
    context 'with_index set to false' do
      let(:options) do
        {
          with_index: false,
          default: Faker::Lorem.word,
          required: true
        }
      end

      it 'should return the value the user selects' do
        allow(highline).to receive(:ask).and_return(1)
        resp = subject.ask(Faker::Lorem.sentence, choices, options)
        expect(resp).to eq({ value: 'one' })
      end

      it 'should recurse multiple times if the user skips' do
        allow(highline).to receive(:ask).and_return(0, 0, 3)
        expect(subject).to receive(:ask).exactly(3).times.and_call_original
        subject.ask(Faker::Lorem.sentence, choices, options)
      end
    end

    context 'with_index set to true' do
      let(:options) do
        {
          with_index: true,
          default: nil,
          required: true
        }
      end

      it 'should return the value the user selects' do
        allow(highline).to receive(:ask).and_return(1)
        resp = subject.ask(Faker::Lorem.sentence, choices, options)
        expect(resp).to eq({ value: 'one', index: 0 })
      end

      it 'should recurse multiple times if the user skips' do
        allow(highline).to receive(:ask).and_return(0, 0, 3)
        expect(subject).to receive(:ask).exactly(3).times.and_call_original
        subject.ask(Faker::Lorem.sentence, choices, options)
      end
    end
  end

  context 'with required set to false' do
    context 'with_index set to false' do
      context 'with default set' do
        let(:options) do
          {
            with_index: false,
            default: 'two',
            required: false
          }
        end

        it 'should return the value the user selects' do
          allow(highline).to receive(:ask).and_return(1)
          resp = subject.ask(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq({ value: 'one' })
        end

        it 'should return the default if the user skips' do
          allow(highline).to receive(:ask).and_return(0)
          resp = subject.ask(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq({ value: 'two' })
        end
      end

      context 'with default nil' do
        let(:options) do
          {
            with_index: false,
            default: nil,
            required: false
          }
        end

        it 'should return the value the user selects' do
          allow(highline).to receive(:ask).and_return(1)
          resp = subject.ask(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq({ value: 'one' })
        end

        it 'should return nil if the user skips' do
          allow(highline).to receive(:ask).and_return(0)
          resp = subject.ask(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq(nil)
        end
      end
    end

    context 'with_index set to true' do
      context 'with default set' do
        let(:options) do
          {
            with_index: true,
            default: 'two',
            required: false
          }
        end

        it 'should return the value the user selects' do
          allow(highline).to receive(:ask).and_return(1)
          resp = subject.ask(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq({ value: 'one', index: 0 })
        end

        it 'should return the default if the user skips' do
          allow(highline).to receive(:ask).and_return(0)
          resp = subject.ask(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq({ value: 'two', index: 1 })
        end
      end

      context 'with default nil' do
        let(:options) do
          {
            with_index: true,
            default: nil,
            required: false
          }
        end

        it 'should return the value the user selects' do
          allow(highline).to receive(:ask).and_return(1)
          resp = subject.ask(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq({ value: 'one', index: 0 })
        end

        it 'should return nil if the user skips' do
          allow(highline).to receive(:ask).and_return(0)
          resp = subject.ask(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq(nil)
        end
      end
    end
  end
end
