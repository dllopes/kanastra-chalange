class BoletoMailer < ApplicationMailer
  def send_boleto
    @boleto = params[:boleto]
    mail(to: @boleto[:email], subject: 'Seu Boleto de Cobrança')
  end
end