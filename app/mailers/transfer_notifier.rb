class TransferNotifier < ActionMailer::Base
  default from: "suporte@cafeazul.com.br"
  
  def completed
    mail(:to => 'rafael@cafeazul.com.br', :subject => 'Transfer completed')
  end
end
