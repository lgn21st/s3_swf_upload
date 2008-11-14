module S3SwfUpload
  module ViewHelpers
    def s3_swf_upload_tag(options = {})
      height        = options[:height] || 70
      width         = options[:width] || 170
      bucket        = options[:bucket] || S3SwfUpload::S3Config.bucket
      access_key_id = options[:access_key_id] || S3SwfUpload::S3Config.access_key_id
      path          = options[:file_path] || ''
      expiration    = options[:expiration] || 1.hours.from_now.strftime('%Y-%m-%dT%H:%M:%S.000Z')
      signature_url = options[:signature_url] || s3_signatures_url
      https         = options[:https] || 'false'
      acl           = options[:acl] || 'private'
      
      js = <<-JS
        <script src="/javascripts/AC_OETags.js" language="javascript"></script>
        <script language="JavaScript" type="text/javascript">
        <!--
        var requiredMajorVersion = 9;
        var requiredMinorVersion = 0;
        var requiredRevision = 124;

        // Version check for the Flash Player that has the ability to start Player Product Install (6.0r65)
        var hasProductInstall = DetectFlashVer(6, 0, 65);

        // Version check based upon the values defined in globals
        var hasRequestedVersion = DetectFlashVer(requiredMajorVersion, requiredMinorVersion, requiredRevision);

        if ( hasProductInstall && !hasRequestedVersion ) {
        	// DO NOT MODIFY THE FOLLOWING FOUR LINES
        	// Location visited after installation is complete if installation is required
        	var MMPlayerType = (isIE == true) ? "ActiveX" : "PlugIn";
        	var MMredirectURL = window.location;
            document.title = document.title.slice(0, 47) + " - Flash Player Installation";
            var MMdoctitle = document.title;

        	AC_FL_RunContent(
        		"src", "playerProductInstall",
        		"FlashVars", "MMredirectURL="+MMredirectURL+'&MMplayerType='+MMPlayerType+'&MMdoctitle='+MMdoctitle+"",
        		"width", "#{width}",
        		"height", "#{height}",
        		"align", "middle",
        		"id", "S3SWFUpload",
        		"quality", "high",
        		"bgcolor", "#869ca7",
        		"name", "S3SWFUpload",
        		"allowScriptAccess","sameDomain",
        		"type", "application/x-shockwave-flash",
        		"pluginspage", "http://www.adobe.com/go/getflashplayer"
        	);
        } else if (hasRequestedVersion) {
        	// if we've detected an acceptable version
        	// embed the Flash Content SWF when all tests are passed
        	AC_FL_RunContent(
        			"src", "/S3SWFUpload",
        			"width", "#{width}",
        			"height", "#{height}",
        			"align", "middle",
        			"id", "S3SWFUpload",
        			"quality", "high",
        			"bgcolor", "#869ca7",
        			"name", "S3SWFUpload",
        			"allowScriptAccess","sameDomain",
        			"type", "application/x-shockwave-flash",
        			"pluginspage", "http://www.adobe.com/go/getflashplayer"
        	);
          } else {  // flash is too old or we can't detect the plugin
            var alternateContent = 'Alternate HTML content should be placed here. '
          	+ 'This content requires the Adobe Flash Player. '
           	+ '<a href=http://www.adobe.com/go/getflash/>Get Flash</a>';
            document.write(alternateContent);  // insert non-flash content
          }


          // -------------------------------- //
          // initial function for S3SWFUpload //
          // -------------------------------- //
          function initS3SWFUpload() {
            document["S3SWFUpload"].initS3SWFUpload(
                "#{access_key_id}",     //AWSAccessKeyId
                "#{bucket}",            //bucket
                "#{path}",              //FilePath
                "#{https}",             //Secure (Use HTTPS, true or false)
                "#{expiration}",        //Expires
                "#{acl}",               //acl
                "#{signature_url}");    //SignatureQueryURL
          }

          // -------------------------------- //
          // S3SWFUpload Complete Callback    //
          // -------------------------------- //
          function S3SWFUploadComplete() {
          }
        // -->
        </script>
      JS
        
      html = content_tag :noscript do
        content_tag :object, :classid => "clsid:D27CDB6E-AE6D-11cf-96B8-444553540000",
                    :id => "S3SWFUpload", :width => "#{width}", :height => "#{height}",
                    :codebase => "http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab" do
          
          %(<param name="movie" value="S3SWFUpload.swf" />)
          %(<param name="quality" value="high" />)
          %(<param name="bgcolor" value="#869ca7" />)
          %(<param name="allowScriptAccess" value="sameDomain" />)
          
          content_tag :embed, :src => "/S3SWFUpload.swf", :quality => "high", :bgcolor => "#869ca7",
                              :width => "#{width}", :height => "#{height}", :name => "S3SWFUpload", :align => "middle",
                              :play => "true",
                              :loop => "false",
                              :quality => "high",
                              :allowScriptAccess => "sameDomain",
                              :type => "application/x-shockwave-flash",
                              :pluginspage => "http://www.adobe.com/go/getflashplayer" do
          end
        end
      end
      
      js + html
    end
  end
end

ActionView::Base.send(:include, S3SwfUpload::ViewHelpers)
