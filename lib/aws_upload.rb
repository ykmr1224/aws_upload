require "aws_upload/version"
require 'aws_upload/form_helper.rb'
require 'aws-sdk'

module AwsUpload

  ##
  # Module method to configure AwsUpload
  # === Examples
  # AwsUpload.configure do |config|
  #   config.aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
  #   config.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  #   config.aws_region = ENV['AWS_REGION']
  #
  #   config.uploader :image do |u|
  #     u.bucket = 'bucket-name'
  #     u.key_prefix = 'some-prefix/'
  #     u.options[:acl] = "public-read"
  #     u.options[:content_length_range] = 0..1024
  #     u.options[:success_action_redirect] = "http://url.to/redirected/pass"
  #   end
  #
  #   config.uploader :csv do |u|
  #     u.bucket = 'bucket-name'
  #     u.key_prefix = 'some-prefix/'
  #     u.options[:acl] = "private"
  #     u.options[:content_length_range] = 0..10240
  #   end
  # end
  def self.configure
    yield self
  end

  # Access key id for upload
  mattr_accessor :aws_access_key_id
  @@aws_access_key_id = nil

  # Secret access key for upload
  mattr_accessor :aws_secret_access_key
  @@aws_secret_access_key = nil

  # S3 bucket region
  mattr_accessor :aws_region
  @@aws_region = ENV['AWS_REGION']

  @@uploaders = {}

  def self.uploader(*args, &block)
    if block_given?
      options = args.extract_options!
      name = args.first || :default
      @@uploaders[name] = Uploader.new().tap{ |u| yield(u) }
    else
      @@uploaders[args.first || :default]
    end
  end

  # Uploader instance will holds upload settings
  class Uploader
    attr_accessor :options, :key_prefix, :bucket

    def initialize
      @options = {}
      @key_prefx = ""
      @bucket = nil
    end
  end
end
