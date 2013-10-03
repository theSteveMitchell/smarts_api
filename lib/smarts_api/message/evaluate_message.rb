class SmartsApi::EvaluateMessage < SmartsApi::Message

  def send(session, obj_hash, decision)
    body = make_form(request_params(session, obj_hash, decision))
    log "Evaluating"
    response = Typhoeus::Request.post(uri,
                                      :method => method,
                                      :headers => {:Accept => "text/json"},
                                      :body => body
    )
    raise SmartsApi::Error, "Rules Evaluation failed failed.  Recieved empty reply" if response.nil? || response.body.blank?
    reply = JSON.parse(response.body)

    raise SmartsApi::Error, "Rules Evaluation failed failed.  Received malformed response." unless reply["Header"] && ["Body"]

    body = reply["Body"]

    if body.blank?
      log "Rules Engine Evaluation failed. \n\n #{body} \n\n #{response.body}"

      raise SmartsApi::Error, "Rules Evaluation failed.  Returned JSON is blank."
    end
    return body
  end

  def request_params(session, obj_hash, decision)
    params = {
        :appId => SmartsApi::Configuration.app_id,
        :reqData => request_document(session, obj_hash, decision),
        :reqTime => timestamp,
        :session => session
    }
    signature = {
        :sign => sign_request(params)
    }
    return params.merge(signature)
  end

  def request_document(session, obj_hash, decision)
    doc = {:OperationId =>1 , :Header => {:SessionId => session, :DecisionId => decision}, :Body => {:Documents => []}}
    doc[:Body][:Documents] = obj_hash
    return doc.to_json
  end

   def uri
      "#{super}evaluate"
    end
end
