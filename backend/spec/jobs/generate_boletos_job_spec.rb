# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe GenerateBoletosJob, type: :job do
  let!(:uploaded_file) { create(:uploaded_file) }
  let!(:unprocessed_debt) { create(:debt, processed: false, uploaded_file:) }
  let!(:processed_debt) { create(:debt, processed: true, uploaded_file:) }

  before do
    Sidekiq::Worker.clear_all
  end

  it 'enqueues BoletoWorker for each unprocessed debt' do
    expect do
      GenerateBoletosJob.perform_now
    end.to change(BoletoWorker.jobs, :size).by(1)

    expect(BoletoWorker).to have_enqueued_sidekiq_job(unprocessed_debt.id)
    expect(BoletoWorker).not_to have_enqueued_sidekiq_job(processed_debt.id)
  end
end
