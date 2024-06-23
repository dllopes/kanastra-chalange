# app/services/debt_importer.rb
class DebtImporter
  def import(chunk)
    Debt.import(chunk, validate: false)
  rescue ActiveRecord::ActiveRecordError => e
    raise ActiveRecord::ActiveRecordError, "Importação falhou: #{e.message}"
  end
end