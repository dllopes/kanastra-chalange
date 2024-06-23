# app/services/csv_processor.rb
require 'smarter_csv'
require 'parallel'

class CsvProcessor
  BATCH_SIZE = 500
  CSV_HEADERS = %i[name government_id email debt_amount debt_due_date debt_id].freeze

  def initialize(file)
    @file = file
  end

  def process(&block)
    Parallel.each(smarter_csv_process, in_threads: 8, &block)
  end

  private

  def smarter_csv_process
    options = {
      chunk_size: BATCH_SIZE,
      headers_in_file: true,
      user_provided_headers: CSV_HEADERS
    }
    SmarterCSV.process(@file.path, options)
  end
end