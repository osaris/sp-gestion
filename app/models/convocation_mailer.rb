class ConvocationMailer < ApplicationMailer

  def convocation(convocation, convocation_fireman)
    fireman = convocation_fireman.fireman
    grade = (convocation_fireman.grade.nil?||convocation.hide_grade) ? "" : Grade::GRADE.index(convocation_fireman.grade)

    setup(fireman.email)
    subject("Convocation")

    content_type("multipart/alternative")

    part "text/plain" do |plain_part|
      plain_part.body = render_message("convocation.plain", :convocation => convocation, :fireman => fireman, :grade => grade)
      plain_part.transfer_encoding = "base64"
    end

    part "text/html" do |html_part|
      html_part.body = render_message("convocation.html", :convocation => convocation, :fireman => fireman, :grade => grade)
      html_part.transfer_encoding = "base64"
    end
  end

  def sending_confirmation(convocation, user_email)
    setup(user_email)
    subject("Confirmation d'envoi de la convocation")

    content_type("multipart/alternative")

    part "text/plain" do |plain_part|
      plain_part.body = render_message("sending_confirmation.plain", :convocation => convocation)
      plain_part.transfer_encoding = "base64"
    end

    part "text/html" do |html_part|
      html_part.body = render_message("sending_confirmation.html", :convocation => convocation)
      html_part.transfer_encoding = "base64"
    end
  end
end
