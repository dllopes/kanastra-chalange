require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe BoletoWorker, type: :worker do
  let!(:uploaded_file) { create(:uploaded_file) }
  let!(:debt) { create(:debt, processed: false, uploaded_file:) }

  before do
    Sidekiq::Worker.clear_all
  end

  it 'calls BoletoService and updates the debt as processed' do
    boleto_service = double('BoletoService')
    allow(BoletoService).to receive(:new).with(debt).and_return(boleto_service)
    allow(boleto_service).to receive(:generate_boleto)

    BoletoWorker.perform_async(debt.id)
    BoletoWorker.drain

    expect(BoletoService).to have_received(:new).with(debt)
    expect(boleto_service).to have_received(:generate_boleto)
    expect(debt.reload.processed).to be_truthy
  end
end