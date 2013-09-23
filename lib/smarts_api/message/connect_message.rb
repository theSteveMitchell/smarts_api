class SmartsApi::ConnectMessage < SmartsApi::Message

    def send
      log "Connecting to #{uri}"
      response = Typhoeus::Request.post(uri,
        :method => method,
        :headers => {:Accept => "text/json"},
        :body => make_form(request_params)
      )
      raise SmartsApi::Error, "Service connection failed.  Recieved empty reply" if response.nil? || response.body.blank?
      reply = JSON.parse(response.body)

      raise SmartsApi::Error, "Connection failed.  Received malformed response." unless reply["Header"] && reply["Header"]["SessionId"]

      session = reply["Header"]["SessionId"]
      raise SmartsApi::Error, "Connection failed.  Did not receive session ID" if session == "00000000-0000-0000-0000-000000000000"

      return session
    end

    def request_document
      {:OperationId =>1 , :Header => {:DeploymentId => SmartsApi::Configuration.project_id}}.to_json
    end

    def request_params
      params = {
          :appId => SmartsApi::Configuration.app_id,
          :pwd => SmartsApi::Configuration.pwd,
          :reqData => request_document,
          :reqTime => self.timestamp,
          :userId =>  SmartsApi::Configuration.user_id,
          :workspaceId => SmartsApi::Configuration.workspace_id
      }
      signature = {
          :sign => sign_request(params)
      }
      return params.merge(signature)
    end

    def uri
      "#{super}connect"
    end

end

