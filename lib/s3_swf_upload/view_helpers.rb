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
      signature_url = options[:signature_url] || s3_signatures_url
      %(
        <script language="JavaScript" type="text/javascript">
        <!--
          function initS3SWFUpload() {
            document["S3SWFUpload"].initS3SWFUpload("#{signature_url}");
          }
        // -->
        </script>
      )
    end
  end
end

ActionView::Base.send(:include, S3SwfUpload::ViewHelpers)