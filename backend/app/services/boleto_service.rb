class BoletoService
  def initialize(debt)
    @debt = debt
  end

  def generate_boleto
    boleto = {
      name: @debt.name,
      government_id: @debt.government_id,
      email: @debt.email,
      amount: @debt.debt_amount,
      due_date: @debt.debt_due_date,
      debt_id: @debt.debt_id
    }

    # TODO: Implementar a geração do boleto em PDF utilizando uma gem apropriada

    send_boleto_email(boleto)
  end

  private

  def send_boleto_email(boleto)
    BoletoMailer.with(boleto: boleto).send_boleto.deliver_now
  end
end