class ContactForm < MailForm::Base
  attribute :name,      validate: true
  attribute :email,     validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :file,      attachment: true

  attribute :message
  attribute :nickname,  captcha: true

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "Friends And Family - Contact Form",
      :to => ENV['CONTACT_FORM_TO'],
      :from => %("#{name}" <#{email}>)
    }
  end
end
