class BoletoWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5

  def perform(debt_id)
    debt = Debt.find(debt_id)
    BoletoService.new(debt).generate_boleto
    debt.update(processed: true)
  rescue StandardError => e
    Rails.logger.error "Failed to process debt ID #{debt_id}: #{e.message}"
    raise e
  end
end