module S3StorerClient
  class Response
    extend Forwardable

    STATUS_IN_JSON_CONSIDERED_ERROR = %w[error timeout]

    attr_reader :response

    def_delegator :response, :headers
    def_delegator :response, :body

    def initialize(response)
      @response = response
    end

    def error?
      response.error? ||
      STATUS_IN_JSON_CONSIDERED_ERROR.include?(json['status'])
    end

    def ok?
      !error?
    end

    def json
      JSON.parse body
    end
  end
end
