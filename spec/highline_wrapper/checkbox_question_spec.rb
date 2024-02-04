# frozen_string_literal: true

require 'spec_helper'
require 'highline_wrapper'

describe HighlineWrapper::CheckboxQuestion do
  let(:choices) { %w[one two three] }
  let(:response) { double(:response, to_i: 3) }
  let(:highline) { double(:highline_cli, ask: response) }

  before do
    allow(HighLine).to receive(:new).and_return(highline)
    allow(subject).to receive(:puts)
  end

  after do
    HighlineWrapper::CheckboxQuestion.instance_variable_set('@highline', nil)
  end

  subject { HighlineWrapper::CheckboxQuestion }

  context 'with the options as defaults' do
    let(:options) do
      {
        with_indexes: false,
        defaults: [],
        required: false
      }
    end

    it 'should ask the highline client ask' do
      expect(highline).to receive(:ask)
      subject.ask(Faker::Lorem.sentence, choices, options)
    end

    it 'should return the value the user selects' do
      allow(highline).to receive(:ask).and_return('1,3')
      resp = subject.ask(Faker::Lorem.sentence, choices, options)
      expect(resp).to eq([{ value: 'one' }, { value: 'three' }])
    end

    it 'should return empty array if the user skips' do
      allow(highline).to receive(:ask).and_return('')
      resp = subject.ask(Faker::Lorem.sentence, choices, options)
      expect(resp).to eq([])
    end

    it 'should call the return empty defaults if the user skips' do
      allow(highline).to receive(:ask).and_return('')
      expect(subject).to receive(:return_empty_defaults)
      subject.ask(Faker::Lorem.sentence, choices, options)
    end
  end

  context 'with required set to true' do
    context 'with_indexes set to false' do
      let(:options) do
        {
          with_indexes: false,
          defaults: [],
          required: true
        }
      end

      it 'should return the value the user selects' do
        allow(highline).to receive(:ask).and_return('1,2')
        resp = subject.ask(Faker::Lorem.sentence, choices, options)
        expect(resp).to eq([{ value: 'one' }, { value: 'two' }])
      end

      it 'should recurse multiple times if the user skips' do
        allow(highline).to receive(:ask).and_return('', '', '3')
        expect(subject).to receive(:ask).exactly(3).times.and_call_original
        subject.ask(Faker::Lorem.sentence, choices, options)
      end
    end

    context 'with_indexes set to true' do
      let(:options) do
        {
          with_indexes: true,
          defaults: [],
          required: true
        }
      end

      it 'should return the value the user selects' do
        allow(highline).to receive(:ask).and_return('1, 3')
        resp = subject.ask(Faker::Lorem.sentence, choices, options)
        expect(resp).to eq([{ value: 'one', index: 0 }, { value: 'three', index: 2 }])
      end

      it 'should recurse multiple times if the user skips' do
        allow(highline).to receive(:ask).and_return('', '', '3')
        expect(subject).to receive(:ask).exactly(3).times.and_call_original
        subject.ask(Faker::Lorem.sentence, choices, options)
      end
    end
  end

  context 'with required set to false' do
    context 'with_indexes set to false' do
      context 'with defaults set' do
        let(:options) do
          {
            indicate_default_message: true,
            with_indexes: false,
            defaults: ['two'],
            required: false
          }
        end

        it 'should return the value the user selects' do
          allow(highline).to receive(:ask).and_return('1, 2')
          resp = subject.ask(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq([{ value: 'one' }, { value: 'two' }])
        end

        it 'should return the default if the user skips' do
          allow(highline).to receive(:ask).and_return('')
          resp = subject.ask(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq([{ value: 'two' }])
        end

        it 'should call to return the defaults if the user skips' do
          allow(highline).to receive(:ask).and_return('')
          expect(subject).to receive(:return_defaults).and_call_original
          expect(subject).to receive(:puts)
          subject.ask(Faker::Lorem.sentence, choices, options)
        end

        context 'when the indicate_default_message is false' do
          let(:options) do
            {
              indicate_default_message: false,
              with_indexes: false,
              defaults: ['two'],
              required: false
            }
          end

          it 'should call to return the defaults if the user skips' do
            allow(highline).to receive(:ask).and_return('')
            expect(subject).to receive(:return_defaults)
            expect(subject).not_to receive(:puts)
            subject.ask(Faker::Lorem.sentence, choices, options)
          end
        end
      end

      context 'with defaults set to []' do
        let(:options) do
          {
            with_indexes: false,
            defaults: [],
            required: false
          }
        end

        it 'should return the value the user selects' do
          allow(highline).to receive(:ask).and_return('1,3')
          resp = subject.ask(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq([{ value: 'one' }, { value: 'three' }])
        end

        it 'should return nil if the user skips' do
          allow(highline).to receive(:ask).and_return('')
          resp = subject.ask(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq([])
        end
      end
    end

    context 'with_indexes set to true' do
      context 'with default set' do
        let(:options) do
          {
            with_indexes: true,
            defaults: ['two'],
            required: false
          }
        end

        it 'should return the value the user selects' do
          allow(highline).to receive(:ask).and_return('1,2')
          resp = subject.ask(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq([{ value: 'one', index: 0 }, { value: 'two', index: 1 }])
        end

        it 'should return the default if the user skips' do
          allow(highline).to receive(:ask).and_return('')
          resp = subject.ask(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq([{ value: 'two', index: 1 }])
        end
      end

      context 'with default nil' do
        let(:options) do
          {
            with_indexes: true,
            defaults: [],
            required: false
          }
        end

        it 'should return the value the user selects' do
          allow(highline).to receive(:ask).and_return('1')
          resp = subject.ask(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq([{ value: 'one', index: 0 }])
        end

        it 'should return [] if the user skips' do
          allow(highline).to receive(:ask).and_return('')
          resp = subject.ask(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq([])
        end

        it 'should call the return empty defaults message' do
          allow(highline).to receive(:ask).and_return('')
          expect(subject).to receive(:return_empty_defaults)
          subject.ask(Faker::Lorem.sentence, choices, options)
        end
      end
    end
  end
end
