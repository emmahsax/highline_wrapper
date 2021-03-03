# frozen_string_literal: true

require 'spec_helper'
require 'highline_wrapper'

describe HighlineWrapper::Client do
  let(:choices) { %w[one two three] }
  let(:response) { double(:response, readline: true, to_i: 3) }
  let(:highline) { double(:highline_cli, ask: response) }

  before do
    allow(HighLine).to receive(:new).and_return(highline)
    allow(subject).to receive(:puts)
  end

  describe '#ask' do
    context 'with the options as defaults' do
      let(:options) do
        {
          secret: false,
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
    end

    context 'with required set to true' do
      let(:options) do
        {
          secret: false,
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
  end

  describe '#ask_yes_no' do
    context 'with the options as defaults' do
      let(:options) do
        {
          default: true,
          required: false
        }
      end

      it 'should ask the highline client ask' do
        expect(highline).to receive(:ask)
        subject.ask_yes_no(Faker::Lorem.sentence, options)
      end

      it 'should return the value the user selects' do
        allow(highline).to receive(:ask).and_return('n')
        resp = subject.ask_yes_no(Faker::Lorem.sentence, options)
        expect(resp).to eq(false)
      end

      it 'should return true if the user skips' do
        allow(highline).to receive(:ask).and_return('')
        resp = subject.ask_yes_no(Faker::Lorem.sentence, options)
        expect(resp).to eq(true)
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
        resp = subject.ask_yes_no(Faker::Lorem.sentence, options)
        expect(resp).to eq(true)
      end

      it 'should recurse multiple times if the user skips' do
        allow(highline).to receive(:ask).and_return('', '', 'y')
        expect(subject).to receive(:ask_yes_no).exactly(3).times.and_call_original
        subject.ask_yes_no(Faker::Lorem.sentence, options)
      end
    end

    context 'with required set to false' do
      let(:options) do
        {
          default: false,
          required: false
        }
      end

      it 'should return the value the user selects' do
        allow(highline).to receive(:ask).and_return('y')
        resp = subject.ask_yes_no(Faker::Lorem.sentence, options)
        expect(resp).to eq(true)
      end

      it 'should return the default if the user skips' do
        allow(highline).to receive(:ask).and_return('')
        resp = subject.ask_yes_no(Faker::Lorem.sentence, options)
        expect(resp).to eq(false)
      end
    end
  end

  describe '#ask_multiple_choice' do
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
        subject.ask_multiple_choice(Faker::Lorem.sentence, choices, options)
      end

      it 'should return the value the user selects' do
        allow(highline).to receive(:ask).and_return(1)
        resp = subject.ask_multiple_choice(Faker::Lorem.sentence, choices, options)
        expect(resp).to eq('one')
      end

      it 'should return nil if the user skips' do
        allow(highline).to receive(:ask).and_return(0)
        resp = subject.ask_multiple_choice(Faker::Lorem.sentence, choices, options)
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
          resp = subject.ask_multiple_choice(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq('one')
        end

        it 'should recurse multiple times if the user skips' do
          allow(highline).to receive(:ask).and_return(0, 0, 3)
          expect(subject).to receive(:ask_multiple_choice).exactly(3).times.and_call_original
          subject.ask_multiple_choice(Faker::Lorem.sentence, choices, options)
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
          resp = subject.ask_multiple_choice(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq({ choice: 'one', index: 0 })
        end

        it 'should recurse multiple times if the user skips' do
          allow(highline).to receive(:ask).and_return(0, 0, 3)
          expect(subject).to receive(:ask_multiple_choice).exactly(3).times.and_call_original
          subject.ask_multiple_choice(Faker::Lorem.sentence, choices, options)
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
            resp = subject.ask_multiple_choice(Faker::Lorem.sentence, choices, options)
            expect(resp).to eq('one')
          end

          it 'should return the default if the user skips' do
            allow(highline).to receive(:ask).and_return(0)
            resp = subject.ask_multiple_choice(Faker::Lorem.sentence, choices, options)
            expect(resp).to eq('two')
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
            resp = subject.ask_multiple_choice(Faker::Lorem.sentence, choices, options)
            expect(resp).to eq('one')
          end

          it 'should return nil if the user skips' do
            allow(highline).to receive(:ask).and_return(0)
            resp = subject.ask_multiple_choice(Faker::Lorem.sentence, choices, options)
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
            resp = subject.ask_multiple_choice(Faker::Lorem.sentence, choices, options)
            expect(resp).to eq({ choice: 'one', index: 0 })
          end

          it 'should return the default if the user skips' do
            allow(highline).to receive(:ask).and_return(0)
            resp = subject.ask_multiple_choice(Faker::Lorem.sentence, choices, options)
            expect(resp).to eq({ choice: 'two', index: 1 })
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
            resp = subject.ask_multiple_choice(Faker::Lorem.sentence, choices, options)
            expect(resp).to eq({ choice: 'one', index: 0 })
          end

          it 'should return nil if the user skips' do
            allow(highline).to receive(:ask).and_return(0)
            resp = subject.ask_multiple_choice(Faker::Lorem.sentence, choices, options)
            expect(resp).to eq(nil)
          end
        end
      end
    end
  end

  describe '#ask_checkbox' do
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
        subject.ask_checkbox(Faker::Lorem.sentence, choices, options)
      end

      it 'should return the value the user selects' do
        allow(highline).to receive(:ask).and_return('1,3')
        resp = subject.ask_checkbox(Faker::Lorem.sentence, choices, options)
        expect(resp).to eq(%w[one three])
      end

      it 'should return empty array if the user skips' do
        allow(highline).to receive(:ask).and_return('')
        resp = subject.ask_checkbox(Faker::Lorem.sentence, choices, options)
        expect(resp).to eq([])
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
          resp = subject.ask_checkbox(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq(%w[one two])
        end

        it 'should recurse multiple times if the user skips' do
          allow(highline).to receive(:ask).and_return('', '', '3')
          expect(subject).to receive(:ask_checkbox).exactly(3).times.and_call_original
          subject.ask_checkbox(Faker::Lorem.sentence, choices, options)
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
          resp = subject.ask_checkbox(Faker::Lorem.sentence, choices, options)
          expect(resp).to eq([{ choice: 'one', index: 0 }, { choice: 'three', index: 2 }])
        end

        it 'should recurse multiple times if the user skips' do
          allow(highline).to receive(:ask).and_return('', '', '3')
          expect(subject).to receive(:ask_checkbox).exactly(3).times.and_call_original
          subject.ask_checkbox(Faker::Lorem.sentence, choices, options)
        end
      end
    end

    context 'with required set to false' do
      context 'with_indexes set to false' do
        context 'with defaults set' do
          let(:options) do
            {
              with_indexes: false,
              defaults: ['two'],
              required: false
            }
          end

          it 'should return the value the user selects' do
            allow(highline).to receive(:ask).and_return('1, 2')
            resp = subject.ask_checkbox(Faker::Lorem.sentence, choices, options)
            expect(resp).to eq(%w[one two])
          end

          it 'should return the default if the user skips' do
            allow(highline).to receive(:ask).and_return('')
            resp = subject.ask_checkbox(Faker::Lorem.sentence, choices, options)
            expect(resp).to eq(['two'])
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
            resp = subject.ask_checkbox(Faker::Lorem.sentence, choices, options)
            expect(resp).to eq(%w[one three])
          end

          it 'should return nil if the user skips' do
            allow(highline).to receive(:ask).and_return('')
            resp = subject.ask_checkbox(Faker::Lorem.sentence, choices, options)
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
            resp = subject.ask_checkbox(Faker::Lorem.sentence, choices, options)
            expect(resp).to eq([{ choice: 'one', index: 0 }, { choice: 'two', index: 1 }])
          end

          it 'should return the default if the user skips' do
            allow(highline).to receive(:ask).and_return('')
            resp = subject.ask_checkbox(Faker::Lorem.sentence, choices, options)
            expect(resp).to eq([{ choice: 'two', index: 1 }])
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
            resp = subject.ask_checkbox(Faker::Lorem.sentence, choices, options)
            expect(resp).to eq([{ choice: 'one', index: 0 }])
          end

          it 'should return [] if the user skips' do
            allow(highline).to receive(:ask).and_return('')
            resp = subject.ask_checkbox(Faker::Lorem.sentence, choices, options)
            expect(resp).to eq([])
          end
        end
      end
    end
  end
end
