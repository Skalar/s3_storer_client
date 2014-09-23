require 'bundler/setup'
require 'webmock/rspec'
require 's3_storer_client'

WebMock.disable_net_connect!
HTTPI.log = false

S3StorerClient::Api.config = S3StorerClient::Config.new(
  api_endpoint: 'https://s3-storer.herokuapp.com',
  basic_auth_user: "xxx",
  basic_auth_pass: "xxx",
  aws_access_key_id: "xxx",
  aws_secret_access_key: "xxx",
  s3_bucket: "xxx",
  s3_region: "xxx"
)
