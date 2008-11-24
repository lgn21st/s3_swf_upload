module S3SwfUpload
  module ViewHelpers
    def s3_swf_upload_tag(options = {})
      height    = options[:height] || 35
      width     = options[:width]  || 300
      js_helper = options[:js_helper].nil? ? true : options[:js_helper]
      
      out = ""
      out << %(
        <script type="text/javascript" src="/javascripts/swfobject.js"></script>
        <script type="text/javascript">
          swfobject.embedSWF("/s3_upload.swf", "s3_upload", "#{width}", "#{height}", "9.0.0");
        </script>
      )
      
      out << %(
        <div id="s3_upload">
          Please <a href="http://www.adobe.com/go/getflashplayer">Update</a> your Flash Player to Flash v9.0.1 or higher...
        </div>
      )
      
      out << s3_swf_upload_init if js_helper
    end
    
    def s3_swf_upload_init(options={})
      signature_url = options[:signature_url] || s3_signatures_url
      %(
        <script language="JavaScript" type="text/javascript">
        <!--
          function s3_upload() { document["s3_upload"].init("#{signature_url}"); }
        </script>
      )
    end
  end
end

ActionView::Base.send(:include, S3SwfUpload::ViewHelpers)
