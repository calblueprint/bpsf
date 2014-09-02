class ThankdonorsForm < MailForm::Base
  attributes :subject,:message,:to,:from,:recipient,:id
  attributes :nickname,   :captcha => true

  def headers
    {
      subject: %(#{subject}),
      to: %(#{to}),
      from: %("#{recipient}" <#{from}>)
    }
  end
end
