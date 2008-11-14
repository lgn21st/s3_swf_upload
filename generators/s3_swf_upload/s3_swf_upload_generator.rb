require File.expand_path(File.dirname(__FILE__) + "/lib/insert_routes.rb")

class S3SwfUploadGenerator < Rails::Generator::Base
  def initialize(runtime_args, runtime_options = {})
    super
  end

  def manifest
    recorded_session = record do |m|
      m.template 'controller.rb',
                  File.join('app/controllers',
                              "s3_signatures_controller.rb")

      m.template 'amazon_s3.yml', File.join('config', "amazon_s3.yml")
      m.template 'initializer.rb', 'config/initializers/s3_swf_upload.rb'
      m.template 'AC_OETags.js', 'public/javascripts/AC_OETags.js'
      m.template 'S3SWFUpload.swf', 'public/S3SWFUpload.swf'

      m.route_resources 's3_signatures'
    end

    recorded_session
  end
end

