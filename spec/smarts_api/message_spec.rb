require 'spec_helper'

describe SmartsApi::Message do

  before (:all) do
      SmartsApi::Message.base_uri = "http://www.versign.com/request/doSomething.aspc"
      SmartsApi::Message.access_key = "secretKey"
    end

  describe 'initializer' do
    it "should keep the logger for logging purposes" do
      logger = Logger.new(STDOUT)
      message = SmartsApi::Message.new(logger)

      message.logger.should == logger

    end
  end

  describe 'timestamp' do
    it "should be formatted correctly" do
      Timecop.freeze(Time.utc(2012, 6, 21, 12, 34, 56))
      SmartsApi::Message.new().timestamp.should == "2012-06-21T12:34:56Z"
      Timecop.return

    end
  end

  describe 'hash encoding' do
    it 'should convert a hash into a url_encoded string' do
      hash = {:a => "123", :b => "aber=/3sd8:&++\\", :c => "hellpo"}

      SmartsApi::Message.new().encode_hash(hash).should == "a=123&b=aber%3D%2F3sd8%3A%26%2B%2B%5C&c=hellpo"

    end

  end

  describe 'ascii conversion' do
    it "should convert a hex string to ascii in the way the service expects" do
      #even if it's wrong...'

      SmartsApi::Message.new().hex_string_to_ascii("3D").should == "="
      SmartsApi::Message.new().hex_string_to_ascii("0B").should == "\v"
      SmartsApi::Message.new().hex_string_to_ascii("52").should == "R"

      hex = "52410baf20302e9e2c31b5ecea597348aa3df3067c58cf35cb5bd94273dc1de0"
      SmartsApi::Message.new().hex_string_to_ascii(hex)
      .should == "RA\v\xAF 0.\x9E,1\xB5\xEC\xEAYsH\xAA=\xF3\x06|X\xCF5\xCB[\xD9Bs\xDC\x1D\xE0"
    end


  end

  #Notes on signing:  The signing algorithm for Sparkling Logic is very brittle and depends on ALL of the
  #values in sparkling_logic.yml, as well as timestamp.  The below tests will fail if any of those settings change.
  #so if the signature does not match the expected, and one of those settings did change, we can update the expected sig.
  describe 'signing' do
    it "should create a correct signature when no params supplied" do
      Timecop.freeze(Time.utc(2012, 6, 21, 12, 34, 56))

        SmartsApi::Message.new().sign_request({})
        .should == "dOqhdTRLwMSUBSO7HZDRTsD63fVVA%2FKnffCn3DuaRnE%3D"
     Timecop.return
    end

    it "should create a correct signature when params supplied" do
      Timecop.freeze(Time.utc(2012, 6, 21, 12, 34, 56))
      params = {:param1 => "nothing", :param2 => "nothing More"}

      SmartsApi::Message.new().sign_request(params)
      .should == "EIvlfFrm7FpotCVp6MIt76P6bz%2BUKWbVaO7pAIclyd8%3D"
      Timecop.return
    end

  end



end
