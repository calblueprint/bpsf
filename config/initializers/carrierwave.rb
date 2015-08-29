CarrierWave.configure do |config|
  config.storage = :aws
  config.aws_bucket = ENV["AWS_S3_BUCKET"]
  config.aws_credentials = {
    access_key_id: ENV["AWS_ACCESS_KEY_ID"],
    secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
  }
  config.aws_acl = :public_read
end
