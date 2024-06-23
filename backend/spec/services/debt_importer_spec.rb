require 'rails_helper'

RSpec.describe DebtImporter, type: :service do
  let(:uploaded_file) { create(:uploaded_file) }

  let(:valid_chunk) do
    [
      { name: 'Elijah Santos', government_id: '9558', email: 'janet95@example.com', debt_amount: '7811', debt_due_date: '2024-01-19', debt_id: 'ea23f2ca-663a-4266-a742-9da4c9f4fcb3', uploaded_file_id: uploaded_file.id },
      { name: 'Samuel Orr', government_id: '5486', email: 'linmichael@example.com', debt_amount: '5662', debt_due_date: '2023-02-25', debt_id: 'acc1794e-b264-4fab-8bb7-3400d4c4734d', uploaded_file_id: uploaded_file.id }
    ]
  end

  let(:invalid_chunk) do
    [
      { name: nil, government_id: '9558', email: 'janet95@example.com', debt_amount: '7811', debt_due_date: '2024-01-19', debt_id: 'ea23f2ca-663a-4266-a742-9da4c9f4fcb3', uploaded_file_id: uploaded_file.id },
      { name: 'Samuel Orr', government_id: '5486', email: 'linmichael@example.com', debt_amount: nil, debt_due_date: '2023-02-25', debt_id: 'acc1794e-b264-4fab-8bb7-3400d4c4734d', uploaded_file_id: uploaded_file.id }
    ]
  end

  let(:importer) { DebtImporter.new }

  describe '#import' do
    context 'when the chunk is valid' do
      it 'imports the data correctly' do
        expect { importer.import(valid_chunk) }.to change { Debt.count }.by(2)

        debt = Debt.find_by(debt_id: 'ea23f2ca-663a-4266-a742-9da4c9f4fcb3')
        expect(debt).not_to be_nil
        expect(debt.name).to eq('Elijah Santos')
        expect(debt.government_id).to eq(9558)
        expect(debt.email).to eq('janet95@example.com')
        expect(debt.debt_amount).to eq(7811.0)
        expect(debt.debt_due_date).to eq(Date.parse('2024-01-19'))
        expect(debt.uploaded_file_id).to eq(uploaded_file.id)
      end
    end

    context 'when the chunk contains invalid data' do
      it 'raises an ActiveRecord::ActiveRecordError' do
        expect { importer.import(invalid_chunk) }.to raise_error(ActiveRecord::ActiveRecordError, /Importação falhou/)
      end
    end
  end
end