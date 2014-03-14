# These are the keys for the testing environment.
# Once testing is done, these keys will be replaced
# and this file should be added to the .gitignore
Stripe.api_key = if Rails.env.development? or Rails.env.test?
    "sk_test_8n2HF9AHRkI3EnL3HQywACDW"
  else
    ENV['stripe_api_key']
  end
STRIPE_PUBLIC_KEY = if Rails.env.development? or Rails.env.test?
    "pk_test_rK5XH7u7IX9Ij5JFM5A12Kme"
  else
    ENV['stripe_public_key']
  end
