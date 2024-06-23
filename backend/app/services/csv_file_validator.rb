# app/services/csv_file_validator.rb
require 'smarter_csv'

class CsvFileValidator
  class InvalidFileFormatError < StandardError; end

  def initialize(file)
    @file = file
  end

  def validate!
    validate_extension!
    validate_content_type!
  end

  private

  def validate_extension!
    unless @file.original_filename.end_with?('.csv')
      raise InvalidFileFormatError, 'Formato de arquivo inválido. Apenas arquivos CSV são permitidos.'
    end
  end

  def validate_content_type!
    if @file.content_type != 'text/csv' && @file.content_type != 'application/vnd.ms-excel'
      raise InvalidFileFormatError, 'Tipo MIME inválido. Apenas arquivos CSV são permitidos.'
    end
  end
end