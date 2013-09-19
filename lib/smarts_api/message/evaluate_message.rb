class SmartsApi::EvaluateMessage < SmartsApi::Message

  def send(session, member, decision)
    body = make_form(request_params(session, member, decision))
    logger.info "Evaluating" if logger.respond_to?(:info)
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
      logger.info "Rules Engine Evaluation failed. \n\n #{body} \n\n #{response.body}"

      raise SmartsApi::Error, "Rules Evaluation failed.  Returned JSON is blank."
    end

    logger.info "Updating issues" if logger.respond_to?(:info)
    update_member_issues member, body
    return body
  end

  def request_params(session, member, decision)
    params = {
        :appId => app_id,
        :reqData => request_document(session, member, decision),
        :reqTime => timestamp,
        :session => session
    }
    signature = {
        :sign => sign_request(params)
    }
    return params.merge(signature)
  end

  def request_document(session, member, decision)
    doc = {:OperationId =>1 , :Header => {:SessionId => session, :DecisionId => decision}, :Body => {:Documents => []}}
    doc[:Body][:Documents] = member.smarts_document
    return doc.to_json
  end

  def update_member_issues(member, body)
    logger.info "Updating member with id #{member.id} Issues and Goals" if logger.respond_to?(:info)
    if body["Documents"].first["identification"]["actor_id"].to_i == member.entity.id
      body["Documents"].first["issues_collection"].each do |issue|
        member.identify_issue(issue["issue_name"], issue["identification_category"], issue["Explanation"])
      end
      member.save
    end
  end

   def uri
      "#{base_uri}evaluate"
    end

    def method
      :post
    end
end
