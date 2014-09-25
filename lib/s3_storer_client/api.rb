require 'httpi'
require 'json'

module S3StorerClient
  class Api
    def self.config
      @config.dup
    end

    def self.config=(config)
      @config = config
    end


    def self.store(urls, options = {})
      new(config).store urls, options
    end

    def self.delete(urls, options = {})
      new(config).delete urls, options
    end


    attr_accessor :config


    def initialize(config)
      @config = config
    end


    # Public: Stores a set of URLs.
    #
    # urls - a hash of URLs, like: {file1: 'url-to-file-1', file2: 'url-to-file-2'}
    # options - a hash of options:
    #   tagLogsWith: Tag you may send as headers to make API tag request with in it's logs.
    #
    # Returns a hash with same keys as the one you provided, but with URLs where the
    # resources now is stored (on S3).
    def store(urls, options = {})
      fail S3StorerClient::InvalidConfigError if config.nil? || config.invalid?
      fail ArgumentError, "No URLs given" if urls.nil? || urls.empty?

      request = build_api_request options
      request.url = store_api_url
      request.body = make_api_body urls: urls

      ::S3StorerClient::Response.new HTTPI.post request
    end


    # Public: Deeltes a set of URLs
    #
    # urls - an array of URLs, like: ['url-to-file-1-on-s3', 'url-to-file-2-on-s3']
    #
    # Returns boolean
    def delete(urls, options = {})
      fail S3StorerClient::InvalidConfigError if config.nil? || config.invalid?
      fail ArgumentError, "No URLs given" if urls.nil? || urls.empty?

      request = build_api_request options
      request.url = delete_api_url
      request.body = make_api_body urls: urls

      ::S3StorerClient::Response.new HTTPI.delete request
    end



    private

    def build_api_request(options = {})
      HTTPI::Request.new.tap do |request|
        request.auth.basic @config.basic_auth_user, @config.basic_auth_pass
        request.open_timeout = 60 * 3 # seconds
        request.read_timeout = 60 * 3 # seconds

        request.headers['Content-Type'] = 'application/json'
        request.headers['Tag-Logs-With'] = options[:tagLogsWith] if options.key? :tagLogsWith
      end
    end

    def make_api_body(hash)
      defaults = {
        options: {
          awsAccessKeyId: @config.aws_access_key_id,
          awsSecretAccessKey: @config.aws_secret_access_key,
          s3Bucket: @config.s3_bucket,
          s3Region: @config.s3_region
        }
      }

      defaults[:options][:cloudfrontHost] = @config.cloudfront_host if @config.cloudfront_host

      defaults.merge(hash).to_json
    end

    def store_api_url
      append_to_api_endpoint '/store'
    end

    def delete_api_url
      append_to_api_endpoint '/delete'
    end

    def append_to_api_endpoint(path)
      endpoint = @config.api_endpoint
      endpoint = endpoint[0..-1] if endpoint[-1] == '/'

      [endpoint, path].join
    end
  end
end
