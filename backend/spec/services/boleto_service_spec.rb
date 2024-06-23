require 'rails_helper'

RSpec.describe BoletoService do
  let!(:uploaded_file) { create(:uploaded_file) }
  let!(:debt) { create(:debt, processed: false, uploaded_file:) }
  let(:service) { BoletoService.new(debt) }

  describe '#generate_boleto' do
    it 'generates boleto and sends email with correct attributes' do
      mailer = double('BoletoMailer')
      allow(BoletoMailer).to receive(:with).and_return(mailer)
      allow(mailer).to receive(:send_boleto).and_return(mailer)
      allow(mailer).to receive(:deliver_now)

      service.generate_boleto

      expect(BoletoMailer).to have_received(:with).with(
        boleto: {
          name: debt.name,
          government_id: debt.government_id,
          email: debt.email,
          amount: debt.debt_amount,
          due_date: debt.debt_due_date,
          debt_id: debt.debt_id
        }
      )
      expect(mailer).to have_received(:send_boleto)
      expect(mailer).to have_received(:deliver_now)
    end
  end
end