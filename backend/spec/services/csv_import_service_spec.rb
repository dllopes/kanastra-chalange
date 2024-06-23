require 'rails_helper'
require 'benchmark'

RSpec.describe CsvImportService do
  include ActiveJob::TestHelper
  let(:small_file_path) { Rails.root.join('spec/fixtures/files/input_light.csv') }
  let(:invalid_file_path) { Rails.root.join('spec/fixtures/files/input_light.txt') }
  let(:invalid_file_header_path) { Rails.root.join('spec/fixtures/files/input_light_no_header.csv') }
  let(:large_file_path) { Rails.root.join('spec/fixtures/files/input_large.csv') }
  let(:small_file) { Rack::Test::UploadedFile.new(small_file_path, 'text/csv') }
  let(:large_file) { Rack::Test::UploadedFile.new(large_file_path, 'text/csv') }
  let(:invalid_file) { Rack::Test::UploadedFile.new(invalid_file_path, 'text/plain') }
  let(:invalid_header_file) { Rack::Test::UploadedFile.new(invalid_file_header_path, 'text/csv') }
  let(:service) { CsvImportService.new(small_file) }
  let(:invalid_service) { CsvImportService.new(invalid_file) }
  let(:incorrect_headers_service) { CsvImportService.new(invalid_header_file) }

  describe '#import' do
    context 'with valid CSV data' do
      it 'imports debts from a small CSV file' do
        time_taken = Benchmark.realtime do
          CsvImportService.new(small_file).import
        end

        expect(Debt.count).to eq(4)
        expect(time_taken).to be < 5.0
      end

      it 'completes the import of a small file in less than 5 seconds' do
        time_taken = Benchmark.realtime do
          CsvImportService.new(small_file).import
        end
        expect(time_taken).to be < 5.0
      end

      it 'completes the import of a large file in less than 60 seconds' do
        time_taken = Benchmark.realtime do
          CsvImportService.new(large_file).import
        end

        expect(Debt.count).to eq(1100000)
        expect(time_taken).to be < 60.0
      end
    end

    it 'calls the validator, processor, and importer' do
      validator = instance_double(CsvFileValidator)
      processor = instance_double(CsvProcessor)
      importer = instance_double(DebtImporter)

      allow(CsvFileValidator).to receive(:new).and_return(validator)
      allow(CsvProcessor).to receive(:new).and_return(processor)
      allow(DebtImporter).to receive(:new).and_return(importer)

      allow(validator).to receive(:validate!).and_return(true)
      allow(processor).to receive(:process).and_yield([{}])
      allow(importer).to receive(:import)

      service = CsvImportService.new(small_file)
      service.import

      expect(validator).to have_received(:validate!)
      expect(processor).to have_received(:process)
      expect(importer).to have_received(:import)
    end
  end
end