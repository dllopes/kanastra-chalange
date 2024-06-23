class GenerateBoletosJob < ApplicationJob
  queue_as :default
  BATCH_SIZE = 1000

  def perform
    Debt.where(processed: false).find_in_batches(batch_size: BATCH_SIZE) do |debts|
      debts.each do |debt|
        BoletoWorker.perform_async(debt.id)
      end
    end
  end
end