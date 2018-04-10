require "stripe"
Stripe.api_key = "sk_test_BQokikJOvBiI2HlWgH4olfQ2"
Stripe.api_base = "https://api-tls12.stripe.com"

begin
  Stripe::Charge.all()
  puts "TLS 1.2 supported, no action required."
rescue OpenSSL::SSL::SSLError, Stripe::APIConnectionError
  puts "TLS 1.2 is not supported. You will need to upgrade your integration."
end
