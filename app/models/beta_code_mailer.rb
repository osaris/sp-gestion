class BetaCodeMailer < ApplicationMailer
  
  def welcome_instructions(beta_code)
    setup(beta_code.email)
    subject("Accès en avant première à SP-Gestion.fr")

    content_type("multipart/alternative")
    
    part "text/plain" do |p|
      p.body = render_message("welcome_instructions.plain", :code => beta_code.code)
      p.transfer_encoding = "base64"
    end

    part "text/html" do |p|
      p.body = render_message("welcome_instructions.html", :code => beta_code.code)
      p.transfer_encoding = "base64"
    end    
  end

  def boost_activation(beta_code)
    setup(beta_code.email)
    subject("Accès en avant première à SP-Gestion.fr")

    content_type("multipart/alternative")
    
    part "text/plain" do |p|
      p.body = render_message("boost_activation.plain", :code => beta_code.code)
      p.transfer_encoding = "base64"
    end

    part "text/html" do |p|
      p.body = render_message("boost_activation.html", :code => beta_code.code)
      p.transfer_encoding = "base64"
    end    
  end

end
