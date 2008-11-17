module S3SwfUpload
  module ViewHelpers
    def s3_swf_upload_tag(options = {})
      height        = options[:height] || 35
      width         = options[:width] || 300
      js_helper     = options[:js_helper].nil? ? true : options[:js_helper]
      
      out = ""
      out << %(
        <script type="text/javascript" src="/javascripts/swfobject.js"></script>
        <script type="text/javascript">
          swfobject.embedSWF("/S3SWFUpload.swf", "S3SWFUpload", "300", "35", "9.0.124");
        </script>
      )
      out << %(<div id="S3SWFUpload"></div>)
      out << js_s3_swf_upload_init if js_helper
    end
    
    def js_s3_swf_upload_init(options={})
      bucket        = options[:bucket] || S3SwfUpload::S3Config.bucket
      access_key_id = options[:access_key_id] || S3SwfUpload::S3Config.access_key_id
      expiration    = options[:expiration] || 1.hours.from_now.strftime('%Y-%m-%dT%H:%M:%S.000Z')
      signature_url = options[:signature_url] || s3_signatures_url
      https         = options[:https] || 'false'
      acl           = options[:acl] || 'private'
      
      %(
        <script language="JavaScript" type="text/javascript">
        <!--
          // -------------------------------- //
          // initial function for S3SWFUpload //
          // -------------------------------- //
          function initS3SWFUpload() {
            document["S3SWFUpload"].initS3SWFUpload(
                "#{access_key_id}",     //AWSAccessKeyId
                "#{bucket}",            //bucket
                "#{https}",             //Secure (Use HTTPS, true or false)
                "#{expiration}",        //Expires
                "#{acl}",               //acl
                "#{signature_url}");    //SignatureQueryURL
          }
        // -->
        </script>
      )
    end
    
    def js_s3_swf_upload_complete
      %(
        <script language="JavaScript" type="text/javascript">
        <!--
          // -------------------------------- //
          // S3SWFUpload Complete Callback    //
          // -------------------------------- //
          function S3SWFUploadComplete(key) {
          }
        // -->
        </script>
      )
    end
  end
end

ActionView::Base.send(:include, S3SwfUpload::ViewHelpers)
