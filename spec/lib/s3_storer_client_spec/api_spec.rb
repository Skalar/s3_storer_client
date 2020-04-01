require 'spec_helper'

describe S3StorerClient::Api do
  subject { described_class.new described_class.config }

  describe "#store" do
    let(:urls) do
      {
        foo: 'http://example.com/foo',
        bar: 'http://example.com/bar'
      }
    end

    let(:response_urls) do
      {
        'foo' => 'http://s3.com/foo',
        'bar' => 'http://s3.com/bar'
      }
    end

    it "fails when config isn't set" do
      subject.config = nil
      expect { subject.store urls }.to raise_error S3StorerClient::InvalidConfigError
    end

    it "fails when config is invalid" do
      expect(subject.config).to receive(:valid?).and_return false

      expect { subject.store urls }.to raise_error S3StorerClient::InvalidConfigError
    end

    it "when no urls given" do
      expect { subject.store({})}.to raise_error ArgumentError
    end

    it "when urls is nil" do
      expect { subject.store nil }.to raise_error ArgumentError
    end

    it "makes a request to the API with the given urls" do
      stub_request(:post, "https://xxx:xxx@s3-storer.herokuapp.com/store")
        .with(body: {
            urls: urls,
            options: {
              awsAccessKeyId: described_class.config.aws_access_key_id,
              awsSecretAccessKey: described_class.config.aws_secret_access_key,
              s3Bucket: described_class.config.s3_bucket,
              s3Region: described_class.config.s3_region
            }
          }
        )
        .to_return(
          status: 200,
          headers: {'Content-Type' => 'application/json'},
          body: {
            status: 'ok',
            urls: response_urls
          }.to_json
        )

      expect(subject.store urls).to be_ok
    end

    it "makes a request to the API with the given make public setting" do
      stub_request(:post, "https://xxx:xxx@s3-storer.herokuapp.com/store")
        .with(body: {
            urls: urls,
            options: {
              awsAccessKeyId: described_class.config.aws_access_key_id,
              awsSecretAccessKey: described_class.config.aws_secret_access_key,
              s3Bucket: described_class.config.s3_bucket,
              s3Region: described_class.config.s3_region,
              makePublic: false
            }
          }
        )
        .to_return(
          status: 200,
          headers: {'Content-Type' => 'application/json'},
          body: {
            status: 'ok',
            urls: response_urls
          }.to_json
        )

      config = described_class.config
      config.make_public = false
      subject = described_class.new config

      expect(subject.store urls).to be_ok
    end

    it "makes a request to the API with the given cloud front" do
      stub_request(:post, "https://xxx:xxx@s3-storer.herokuapp.com/store")
        .with(body: {
            urls: urls,
            options: {
              awsAccessKeyId: described_class.config.aws_access_key_id,
              awsSecretAccessKey: described_class.config.aws_secret_access_key,
              s3Bucket: described_class.config.s3_bucket,
              s3Region: described_class.config.s3_region,
              cloudfrontHost: 'cdn.example.com'
            }
          }
        )
        .to_return(
          status: 200,
          headers: {'Content-Type' => 'application/json'},
          body: {
            status: 'ok',
            urls: response_urls
          }.to_json
        )

      config = described_class.config
      config.cloudfront_host = 'cdn.example.com'
      subject = described_class.new config

      expect(subject.store urls).to be_ok
    end

    it "includes tagLogsWith as a header" do
      stub_request(:post, "https://xxx:xxx@s3-storer.herokuapp.com/store")
        .with(headers: {
          'Tag-Logs-With' => 'my tag'
        }
        )
        .to_return(
          status: 200,
          body: { status: 'ok'}
        )

      subject.store urls, tagLogsWith: 'my tag'
    end

    it "contains expected json" do
      stub_request(:post, "https://xxx:xxx@s3-storer.herokuapp.com/store")
        .to_return(
          status: 200,
          headers: {'Content-Type' => 'application/json'},
          body: {
            status: 'ok',
            urls: response_urls
          }.to_json
        )

      expect(subject.store(urls).json).to eq(
        'status' => 'ok',
        'urls' => response_urls
      )
    end

    it "is not ok when status in response is error" do
      stub_request(:post, "https://xxx:xxx@s3-storer.herokuapp.com/store")
        .to_return(
          status: 200,
          headers: {'Content-Type' => 'application/json'},
          body: { status: 'error' }.to_json
        )

      expect(subject.store urls).to be_error
    end

    it "is not ok when status in response is timeout" do
      stub_request(:post, "https://xxx:xxx@s3-storer.herokuapp.com/store")
        .to_return(
          status: 200,
          headers: {'Content-Type' => 'application/json'},
          body: { status: 'error' }.to_json
        )

      expect(subject.store urls).to be_error
    end

    it "is not ok when server fails with 500 internal server error" do
      stub_request(:post, "https://xxx:xxx@s3-storer.herokuapp.com/store")
      .to_return status: 500

      expect(subject.store urls).to be_error
    end

    it "is not ok when server fails with 422 internal server error" do
      stub_request(:post, "https://xxx:xxx@s3-storer.herokuapp.com/store")
      .to_return status: 422

      expect(subject.store urls).to be_error
    end
  end





  describe "#delete" do
    let(:urls) do
      [
        'http://example.com/foo', 'http://example.com/bar'
      ]
    end

    it "fails when config isn't set" do
      subject.config = nil
      expect { subject.delete urls }.to raise_error S3StorerClient::InvalidConfigError
    end

    it "fails when config is invalid" do
      expect(subject.config).to receive(:valid?).and_return false

      expect { subject.delete urls }.to raise_error S3StorerClient::InvalidConfigError
    end

    it "when no urls given" do
      expect { subject.delete [] }.to raise_error ArgumentError
    end

    it "when urls is nil" do
      expect { subject.delete nil }.to raise_error ArgumentError
    end

    it "makes a request to the API with the given urls" do
      stub_request(:delete, "https://xxx:xxx@s3-storer.herokuapp.com/delete")
        .with(body: {
            urls: urls,
            options: {
              awsAccessKeyId: described_class.config.aws_access_key_id,
              awsSecretAccessKey: described_class.config.aws_secret_access_key,
              s3Bucket: described_class.config.s3_bucket,
              s3Region: described_class.config.s3_region
            }
          }
        )
        .to_return(
          status: 200,
          headers: {'Content-Type' => 'application/json'},
          body: { status: 'ok' }.to_json
        )

      expect(subject.delete urls).to be_ok
    end


    it "includes tagLogsWith as a header" do
      stub_request(:delete, "https://xxx:xxx@s3-storer.herokuapp.com/delete")
        .with(headers: {
          'Tag-Logs-With' => 'my secret tag'
        }
        )
        .to_return(
          status: 200,
          body: { status: 'ok'}
        )

      subject.delete urls, tagLogsWith: 'my secret tag'
    end

    it "contains expected json" do
      stub_request(:delete, "https://xxx:xxx@s3-storer.herokuapp.com/delete")
        .to_return(
          status: 200,
          headers: {'Content-Type' => 'application/json'},
          body: { status: 'ok' }.to_json
        )

      expect(subject.delete(urls).json).to eq('status' => 'ok')
    end

    it "is not ok when status in response is error" do
      stub_request(:delete, "https://xxx:xxx@s3-storer.herokuapp.com/delete")
        .to_return(
          status: 200,
          headers: {'Content-Type' => 'application/json'},
          body: { status: 'error' }.to_json
        )

      expect(subject.delete urls).to be_error
    end

    it "is not ok when status in response is timeout" do
      stub_request(:delete, "https://xxx:xxx@s3-storer.herokuapp.com/delete")
        .to_return(
          status: 200,
          headers: {'Content-Type' => 'application/json'},
          body: { status: 'error' }.to_json
        )

      expect(subject.delete urls).to be_error
    end

    it "is not ok when server fails with 500 internal server error" do
      stub_request(:delete, "https://xxx:xxx@s3-storer.herokuapp.com/delete")
      .to_return status: 500

      expect(subject.delete urls).to be_error
    end

    it "is not ok when server fails with 422 internal server error" do
      stub_request(:delete, "https://xxx:xxx@s3-storer.herokuapp.com/delete")
      .to_return status: 422

      expect(subject.delete urls).to be_error
    end
  end
end
