# S3StorerClient

A very thin wrapper client around [S3 Storer](https://github.com/Skalar/s3_storer)'s API
Please see the documentation for S3 Storer's API on [their page](https://github.com/Skalar/s3_storer).

## Usage

```ruby
# Set up config

S3StorerClient::Api.config = S3StorerClient::Config.new(
  api_endpoint: 'https://s3-storer.herokuapp.com',
  basic_auth_user: "xxx",
  basic_auth_pass: "xxx",
  aws_access_key_id: "xxx",
  aws_secret_access_key: "xxx",
  s3_bucket: "xxx",
  s3_region: "xxx"
)

# Make requests to store

urls = {
  my: 'http://www.example.com/urls'
  urls: 'http://www.example.com/i/want/stored'
}
response = S3StorerClient.store urls
response.ok?
response.json['urls']['my'] # => returns url where example.com/i/want/stored now is coped to S3.

# Delete urls

urls = [
  'http://www.s3.com/urls', 'http://www.se.com/i/want/deleted'
]

response = S3StorerClient.delete urls
response.ok?

```


## Installation

Add this line to your application's Gemfile:

```ruby
gem 's3_storer_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install s3_storer_client

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/s3_storer_client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
