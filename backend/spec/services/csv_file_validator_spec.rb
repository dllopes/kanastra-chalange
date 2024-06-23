# spec/services/csv_file_validator_spec.rb
require 'rails_helper'

RSpec.describe CsvFileValidator, type: :service do
  let(:valid_file_path) { Rails.root.join('spec', 'fixtures', 'files', 'input_light.csv') }
  let(:invalid_extension_file_path) { Rails.root.join('spec', 'fixtures', 'files', 'input_invalid.txt') }

  let(:valid_file) { fixture_file_upload(valid_file_path, 'text/csv') }
  let(:invalid_extension_file) { fixture_file_upload(invalid_extension_file_path, 'text/plain') }

  describe '#validate!' do
    context 'when the file has a valid format' do
      it 'does not raise any error' do
        validator = CsvFileValidator.new(valid_file)
        expect { validator.validate! }.not_to raise_error
      end
    end

    context 'when the file has an invalid extension' do
      it 'raises an InvalidFileFormatError' do
        validator = CsvFileValidator.new(invalid_extension_file)
        expect { validator.validate! }.to raise_error(CsvFileValidator::InvalidFileFormatError, 'Formato de arquivo inválido. Apenas arquivos CSV são permitidos.')
      end
    end
  end
end