# spec/services/csv_processor_spec.rb
require 'rails_helper'

RSpec.describe CsvProcessor, type: :service do
  let(:valid_file_path) { Rails.root.join('spec', 'fixtures', 'files', 'input_light.csv') }
  let(:large_file_path) { Rails.root.join('spec', 'fixtures', 'files', 'input_large.csv') }
  let(:valid_file) { fixture_file_upload(valid_file_path, 'text/csv') }
  let(:large_file) { fixture_file_upload(large_file_path, 'text/csv') }

  describe '#process' do
    context 'when the file has a valid format' do
      it 'processes the file in chunks' do
        processor = CsvProcessor.new(valid_file)
        chunks = []
        processor.process do |chunk|
          chunks << chunk
        end
        expect(chunks).not_to be_empty
        expect(chunks.first).to all(be_a(Hash))
      end

      it 'calls SmarterCSV to process the file' do
        processor = CsvProcessor.new(valid_file)
        allow(SmarterCSV).to receive(:process).and_call_original
        processor.process { |chunk| chunk }
        expect(SmarterCSV).to have_received(:process).with(valid_file.path, kind_of(Hash))
      end

      it 'calls Parallel.each to process the chunks' do
        processor = CsvProcessor.new(valid_file)
        allow(Parallel).to receive(:each).and_call_original
        processor.process { |chunk| chunk }
        expect(Parallel).to have_received(:each).with(anything, in_threads: 8)
      end
    end

    context 'when the file is empty' do
      let(:empty_file_path) { Rails.root.join('spec', 'fixtures', 'files', 'input_empty.csv') }
      let(:empty_file) { fixture_file_upload(empty_file_path, 'text/csv') }

      it 'does not yield any chunks' do
        processor = CsvProcessor.new(empty_file)
        chunks = []
        processor.process do |chunk|
          chunks << chunk
        end
        expect(chunks).to be_empty
      end
    end
  end
end