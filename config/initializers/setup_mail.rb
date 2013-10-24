ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "gmail.com",
  :user_name => "YOUR_TEST_EMAIL@gmail.com",
  :password => "YOUR_PASSWORD",
  :authentication => "plain",
  :enable_starttls_auto => true #This line is must to ensure the tls for Gmail
}