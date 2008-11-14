require 'base64'

class S3SignaturesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  include S3SwfUpload::Signature
  
  def index
  end
  
  def create
    expiration_date = params[:expiration_date]
    bucket = params[:bucket]
    file_path   = params[:file_path]
    key    = params[:key]
    acl    = params[:acl]
    content_type = params[:content_type]
    
    policy = Base64.encode64(
"{
    'expiration': '#{expiration_date}',
    'conditions': [
        {'bucket': '#{bucket}'},
        {'key': '#{key}'},
        {'acl': '#{acl}'},
        {'Content-Type': '#{content_type}'},
        ['starts-with', '$Filename', ''],
        ['eq', '$success_action_status', '201']
    ]
}").gsub(/\n|\r/, '')
    
    signature = b64_hmac_sha1(S3SwfUpload::S3Config.secret_access_key, policy)
           
    respond_to do |format|
      format.xml { 
        render :xml => <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<s3>
  <policy>#{policy}</policy>
  <signature>#{signature}</signature>
</s3>
        XML
      }
    end
  end
end
