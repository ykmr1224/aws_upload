require 'spec_helper'

describe AwsUpload do
  it 'has a version number' do
    expect(AwsUpload::VERSION).not_to be_nil
  end

  before(:all) do
    AwsUpload::configure do |config|
      config.aws_access_key_id = "some_key"
      config.aws_secret_access_key = "some_secret"
      config.aws_region = "us-west-2"

      #default
      config.uploader do |u|
        u.bucket = 'default-bucket'
        u.key_prefix = 'some-prefix/'
        u.options[:acl] = "private"
        u.options[:content_length_range] = 0..10240
      end

      #named uploader
      config.uploader :image do |u|
        u.bucket = 'image-bucket'
        u.key_prefix = 'img-'
        u.options[:acl] = "public-read"
        u.options[:content_length_range] = 0..1024
        u.options[:success_action_redirect] = "http://url.to/redirected/pass"
      end
    end
  end

  describe "configure" do
    it 'setup access credentials' do
      expect(AwsUpload::aws_access_key_id).to eql("some_key")
      expect(AwsUpload::aws_secret_access_key).to eql("some_secret")
      expect(AwsUpload::aws_region).to eql("us-west-2")
    end

    it 'setup default uploader' do
      expect(AwsUpload::uploader().bucket).to eql("default-bucket")
      expect(AwsUpload::uploader().key_prefix).to eql("some-prefix/")
      expect(AwsUpload::uploader().options[:acl]).to eql("private")
      expect(AwsUpload::uploader().options[:content_length_range]).to eql(0..10240)
    end

    it 'setup named uploader' do
      expect(AwsUpload::uploader(:image).bucket).to eql("image-bucket")
      expect(AwsUpload::uploader(:image).key_prefix).to eql("img-")
      expect(AwsUpload::uploader(:image).options[:acl]).to eql("public-read")
      expect(AwsUpload::uploader(:image).options[:content_length_range]).to eql(0..1024)
      expect(AwsUpload::uploader(:image).options[:success_action_redirect]).to eql("http://url.to/redirected/pass")
    end
  end

  describe "form-helper" do
    it "add aws_upload_form method to ActionView::Base" do
      expect(ActionView::Base.instance_methods).to include(:aws_upload_form)
    end

    describe "#aws_upload_form" do
      it "return generated form" do
        form_html = AwsUpload::FormHelper.aws_upload_form :image, "objname"
        expect(form_html).to include("<form action='https://image-bucket.s3-us-west-2.amazonaws.com' method='post' enctype='multipart/form-data'>")
        expect(form_html).to be_html_safe
      end

      it "return allows block to specify file input and submit button" do
        form_html = AwsUpload::FormHelper.aws_upload_form :image, "objname" do
          "<input type='file' name='file' id='special'><input type='submit' value='GO!'>"
        end
        expect(form_html).to include("<input type='file' name='file' id='special'><input type='submit' value='GO!'>")
        expect(form_html).to be_html_safe
      end
    end
  end

end
