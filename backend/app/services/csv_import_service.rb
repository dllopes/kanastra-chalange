# app/services/csv_import_service.rb
class CsvImportService
  def initialize(file)
    @file = file
    @validator = CsvFileValidator.new(file)
    @processor = CsvProcessor.new(file)
    @importer = DebtImporter.new
  end

  def import
    @validator.validate!
    uploaded_file_id = create_file_uploaded!.id
    ActiveRecord::Base.transaction do
      @processor.process do |chunk|
        chunk = chunk.map do |item|
          item.merge(uploaded_file_id: uploaded_file_id)
        end
        @importer.import(chunk)
      end
    rescue StandardError => e
      uploaded_file.destroy
      raise e
    end
  end

  private

  def create_file_uploaded!
    UploadedFile.create(filename: @file.original_filename)
  end
end