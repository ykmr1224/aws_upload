require 'action_view'

module AwsUpload
  ##
  # This module creates aws direct upload form helper
  # === Examples
  # Generate a form to upload a file with the name of "uploaded_file.jpg"
  # <%= aws_upload_form(:image, "uploaded_file.jpg") %>
  #
  # Generate a form to upload a file with the uploaded file name
  # <%= aws_upload_form(:image, "${filename}") %>
  #
  # You can specify options. It will override the options specified in the configuration.
  # <%= aws_upload_form(:image, "uploaded_file.jpg", acl: "private", metadata: {original-filename: '${filename'}) %>
  #
  # You can customize file and submit input by giving a block.
  # <%= aws_upload_form(:image, "uploaded_file.jpg") do %>
  #   <input type="file" name="file">
  #   <input type="submit" value="Upload">
  # <% end %>
  #
  module FormHelper
    extend self

    def aws_upload_form(name, object_key, options={})
      # Load credentials
      if AwsUpload.aws_access_key_id
        creds = Aws::Credentials.new(AwsUpload.aws_access_key_id, AwsUpload.aws_secret_access_key)
      else
        # Use shared credentials if aws_access_key_id is not specified
        creds = Aws::SharedCredentials.new()
      end

      region = AwsUpload.aws_region

      uploader = AwsUpload.uploader(name)
      opts = uploader.options.deep_merge(options)
      opts[:key] = uploader.key_prefix + object_key

      post = Aws::S3::PresignedPost.new(creds, region, uploader.bucket, opts)
      form = "<form action='#{post.url.to_s}' method='post' enctype='multipart/form-data'>\n"
      post.fields.each do |key, value|
        form << "\t<input type='hidden' name='#{key}' value='#{value}'>\n"
      end

      # render file and submit inputs. yield block if a block is given.
      if block_given?
        form << yield
      else
        form << "\t<input type='file' name='file'>\n"
        form << "\t<input type='submit' value='upload'>\n"
      end

      form << "</form>"
      form.html_safe
    end
  end
end

ActionView::Base.send :include, AwsUpload::FormHelper
