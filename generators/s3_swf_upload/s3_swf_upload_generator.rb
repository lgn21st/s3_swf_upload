require File.expand_path(File.dirname(__FILE__) + "/lib/insert_routes.rb")

class S3SwfUploadGenerator < Rails::Generator::Base
  def initialize(runtime_args, runtime_options = {})
    super
  end

  def manifest
    record do |m|
      m.file 'controller.rb', 'app/controllers/s3_signatures_controller.rb'
      m.file 'amazon_s3.yml', 'config/amazon_s3.yml'
      m.file 'initializer.rb', 'config/initializers/s3_swf_upload.rb'
      m.file 'AC_OETags.js', 'public/javascripts/AC_OETags.js'
      m.file 'S3SWFUpload.swf', 'public/S3SWFUpload.swf'
      m.route_resources 's3_signatures'
    end
  end
end

