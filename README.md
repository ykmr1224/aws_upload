# AwsUpload

This gem offers a helper method to build a form HTML to upload directry to Amazon S3 storage by using POST method.
With this gem, you can easily exclude settings for aws s3 direct upload and generate upload form by calling a single helper method.

## Installation

Add this line to your application's Gemfile:

    gem 'aws_upload'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aws_upload

## Usage

Make your initialization script to configure uploading parameters.

in config/initializers/aws_uplaod.rb
```ruby
  AwsUpload.configure do |config|
    config.aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
    config.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    config.aws_region = ENV['AWS_REGION']

    config.uploader :image do |u|
      u.bucket = 'bucket-name'
      u.key_prefix = 'some-prefix/'
      u.options[:acl] = "public-read"
      u.options[:content_length_range] = 0..1024
      u.options[:success_action_redirect] = "http://url.to/redirected/pass"
    end
  end
```

Call aws_upload_form method from view erb file.

```erb
  Generate a form to upload a file with the name of "uploaded_file.jpg"
  <%= aws_upload_form(:image, "uploaded_file.jpg") %>

  Generate a form to upload a file with the uploaded file name
  <%= aws_upload_form(:image, "${filename}") %>

  You can specify options. It will override the options specified in the configuration.
  <%= aws_upload_form(:image, "uploaded_file.jpg", acl: "private", metadata: {original-filename: '${filename'}) %>

  You can customize file and submit input by giving a block.
  <%= aws_upload_form(:image, "uploaded_file.jpg") do %>
    <input type="file" name="file">
    <input type="submit" value="Upload">
  <% end %>
```

You can find further options in AWS::S3::PresignedPost document, which is internaly used in this gem.
http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/S3/PresignedPost.html#initialize-instance_method

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
