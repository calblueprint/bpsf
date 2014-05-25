class ThankdonorsForm < MailForm::Base
  attributes :subject
  attributes :message
  attributes :to
  attributes :from
  attributes :recipient
  attributes :id
  attributes :nickname,   :captcha => true

  def headers
    {
      :subject => %(#{subject}),
      :to => %(#{to}),
      :from => %("#{recipient}" <#{from}>)
    }
  end
end