require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:file) { fixture_file_upload('input_light.csv', 'text/csv') }
  let(:csv_import_service) { instance_double(CsvImportService) }

  before do
    allow(CsvImportService).to receive(:new).with(any_args).and_return(csv_import_service)
  end

  describe 'POST #create' do
    context 'when a file is uploaded' do
      it 'processes the file successfully' do
        allow(csv_import_service).to receive(:import).and_return(true)

        post :create, params: { file: file }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to eq({ 'message' => 'Arquivo processado com sucesso' })
      end
    end

    context 'when no file is uploaded' do
      it 'returns an error' do
        post :create, params: { file: nil }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Nenhum arquivo enviado' })
      end
    end

    context 'when the file format is invalid' do
      it 'returns an error' do
        allow(csv_import_service).to receive(:import).and_raise(CsvFileValidator::InvalidFileFormatError.new('Formato inválido'))

        post :create, params: { file: file }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Formato inválido' })
      end
    end

    context 'when an unexpected error occurs' do
      it 'returns a generic error message' do
        allow(csv_import_service).to receive(:import).and_raise(StandardError.new('Erro inesperado'))

        post :create, params: { file: file }

        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Ocorreu um erro inesperado', 'message' => 'Erro inesperado' })
      end
    end
  end

  describe 'GET #index' do
    let!(:file_uploads) { create_list(:uploaded_file, 30) }

    it 'returns paginated file uploads' do
      get :index, params: { page: 1, per_page: 10 }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(10)
    end

    it 'returns the default number of file uploads per page' do
      get :index, params: { page: 1 }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(25)
    end
  end
end