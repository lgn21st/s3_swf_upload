require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe S3SignaturesController do

  describe 'Handle post /s3_signatures' do
    
    before do
      Base64.stub!(:encode64).and_return('ew0gICAgJ2V4cGlyYXRpb24nOiAnMjA')
      controller.stub!(:b64_hmac_sha1).and_return('ohCdgA1RVuslXxJlzL9uFh7pR1M=')
    end
    
    def do_post
      post :create, :expiration_date => '2008-12-31T12:00:00.000Z', :bucket => 'elc',
              :key => 'demo.jpg', :acl => 'private', :content_type => 'image/jpeg'
    end
    
    it "should be success" do
      do_post
      response.should be_success
    end
    
    it "should encode the policy with base64" do
      Base64.should_receive(:encode64).and_return('ew0gICAgJ2V4cGlyYXRpb24nOiAnMjA')
      do_post
    end
    
    it "should encrypt the policy with hmac_sha1" do
      do_post
      puts response.body
      response.body.should == 'ohCdgA1RVuslXxJlzL9uFh7pR1M='
    end
  end
end
