class FilesController < ApplicationController
  def create
    file = params[:file]

    if file.blank?
      render json: { error: 'Nenhum arquivo enviado' }, status: :bad_request
      return
    end

    begin
      CsvImportService.new(file).import
      render json: { message: 'Arquivo processado com sucesso' }, status: :created
    rescue CsvFileValidator::InvalidFileFormatError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue => e
      render json: { error: 'Ocorreu um erro inesperado', message: e.message }, status: :internal_server_error
    end
  end

  def index
    file_uploads = UploadedFile.order(created_at: :desc).page(params[:page]).per(params[:per_page] || 25)
    render json: file_uploads
  end
end