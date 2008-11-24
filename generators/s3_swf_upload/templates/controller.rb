require 'base64'

class S3UploadsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  include S3SwfUpload::Signature
  
  def index
    bucket          = S3SwfUpload::S3Config.bucket
    access_key_id   = S3SwfUpload::S3Config.access_key_id
    key             = params[:key]
    content_type    = params[:content_type]
    file_size       = params[:file_size]
    acl             = 'private'
    https           = 'false'
    expiration_date = 1.hours.from_now.strftime('%Y-%m-%dT%H:%M:%S.000Z')

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
        render :xml => {
          :policy          => policy,
          :signature       => signature,
          :bucket          => bucket,
          :accesskeyid     => access_key_id,
          :acl             => acl,
          :expirationdate  => expiration_date,
          :https           => https
        }.to_xml
      }
    end
  end
end
