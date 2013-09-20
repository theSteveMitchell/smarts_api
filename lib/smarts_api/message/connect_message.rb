class SmartsApi::ConnectMessage < SmartsApi::Message

    def send
      logger.info "Connecting to #{uri}" if logger.respond_to?(:info)
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
      {:OperationId =>1 , :Header => {:DeploymentId => project_id}}.to_json
    end

    def request_params
      params = {
          :appId => app_id,
          :pwd => pwd,
          :reqData => request_document,
          :reqTime => self.timestamp,
          :userId =>  user_id,
          :workspaceId => workspace_id
      }
      signature = {
          :sign => sign_request(params)
      }
      return params.merge(signature)
    end

    def uri
      "#{base_uri}connect"
    end

end

