class ThankdonorsForm < MailForm::Base
  attribute :subject,      :validate => true
  attribute :message,     :validate => true
  attribute :id

  def headers
    {
      :subject => %(#{id}),
      :to => 'heyjaylin@gmail.com',
      :from => 'heyjaylin@gmail.com'
    }
  end
end