require 'typhoeus'
require 'json'
require 'active_support/core_ext/class'
require 'active_support/core_ext/array'
include ERB::Util
require 'openssl'
require 'base64'

class SmartsApi::Message
  attr_reader :logger
  cattr_accessor :user_id, :pwd, :app_id, :workspace_id, :access_key, :base_uri, :project_id


  def initialize(logger)
    @logger = logger
  end

  def sign_request(params)
    #Below you will find the reverse-engineered ruby implementation of Sparkling Logic's security signing algorithm.
    #It is a very poorly designed encryption algorithm, originally written in javascript, by some junior developer at Sparkling Logic.
    #You will find notes along the way to help indicate what's going on.
      #This will not be over quickly
      #Your will not enjoy this.\
      #I am not your king.

    #The params object MUST include EXACTLY these parameters, in this order: AppId, pwd, reqData, reqTime, userID, and workspaceID.
    #combine the parameters into a long encoded string (again, order of elements is critical)
    encoded_parts = []
    http = URI.parse(uri)
    encoded_parts[0] = method.to_s.upcase
    encoded_parts[1] = http.host
    encoded_parts[2] = http.request_uri
    encoded_parts[3] = encode_hash(params)

    encoded = encoded_parts.join("\n") #Join parts with newline character

    #5 Digest the encode string with SHA256, using the pre-shared AccessKey as the digest key.
    digest = OpenSSL::Digest::Digest.new('sha256')
    hash = OpenSSL::HMAC.hexdigest(digest, access_key, encoded)

    #6 OpenSSL::Digest correctly translates the Hash to a string of bytes.  Sparkling Logic's algorithm incorrectly converts the hex value to the corresponding ascii code.
    #So we need to iterate each pair in our byte string and convert to ascii. this is incredibly gross, but c'est la vie
    #7 AND THEN we encode the string to base64 for absolutely no logical reason.
    signature =  Base64.encode64(hex_string_to_ascii(hash))
    #8 re-URL_encode the string and remove line-endings.  Again, for absolutely no logical reason.  I think the javascript version did this automatically.
    signature =  url_encode(signature)
    signature =  signature.gsub("%0A", "" )
    return signature

  end


  def hex_string_to_ascii hex_str
    #we need to iterate our hex-string and convert each pair to a hex-number.  Then evaluate that as ascii code and replace with the corresponding ascii character.
    ascii_str = ''
    hex_str.split('').in_groups_of(2){|c| ascii_str << (c[0]+c[1]).hex.chr }
    ascii_str
  end

  def timestamp
    Time.now.utc.iso8601.to_s # => "2012-06-21T18:15:09Z"
  end

  def encode_hash(hash)
    new = []
    hash.each do |k,v|
      new << k.to_s+"="+url_encode(v)
    end
    return new.join("&")
  end

  def make_form(request_params)
    request_params.map{|k,v| "#{k}=#{v}"}.join("&")
  end
end
