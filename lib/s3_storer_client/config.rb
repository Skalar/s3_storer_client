module S3StorerClient
  class Config
    REQUIRED = %w[
      api_endpoint basic_auth_user basic_auth_pass
      aws_access_key_id aws_secret_access_key s3_bucket s3_region
    ]
    OPTIONAL = %w[
      cloudfront_host
    ]

    attr_accessor *REQUIRED
    attr_accessor *OPTIONAL

    def initialize(attributes = {})
      assign attributes
    end

    def valid?
      REQUIRED.all? do |attr|
        self[attr].to_s.length > 0
      end
    end

    def invalid?
      !valid?
    end

    def []=(name, value)
      public_send "#{name}=", value
    end

    def [](name)
      public_send name
    end

    # One of: none, peer, fail_if_no_peer_cert, or client_once.
    def ssl_verify_mode=(mode)
      @ssl_verify_mode = mode
    end

    def ssl_verify_mode
      @ssl_verify_mode
    end



    private

    def assign(attributes)
      attributes.each_pair do |name, value|
        self[name] = value
      end
    end

  end
end
