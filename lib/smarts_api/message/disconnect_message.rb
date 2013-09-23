class SmartsApi::DisconnectMessage < SmartsApi::Message


  def send(session)
    body = make_form(request_params(session))
    log "Disconnecting"
    response = Typhoeus::Request.post(uri,
                                      :method  => method,
                                      :headers => {:Accept => "text/json"},
                                      :body    => body
    )
    raise SmartsApi::Error, "Service connection failed.  Recieved empty reply" if response.nil? || response.body.blank?
    reply = JSON.parse(response.body)

    raise SmartsApi::Error, "Connection failed.  Received malformed response." unless reply["Header"] && reply["Header"]["SessionId"]

    session = reply["Header"]["SessionId"]
    raise SmartsApi::Error, "Connection failed.  Did not receive session ID" if session == "00000000-0000-0000-0000-000000000000"
    return session
  end

  def request_params(session)
    params = {
        :appId => SmartsApi::Configuration.app_id,
        :reqTime => timestamp,
        :session => session
    }
    signature = {
        :sign => sign_request(params)
    }
    return params.merge(signature)
  end

  def uri
    "#{super}disconnect"
  end


end
