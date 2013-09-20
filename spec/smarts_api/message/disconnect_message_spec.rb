require 'spec_helper'


describe SmartsApi::DisconnectMessage do
  it 'should return session ID if successful' do

    stub_http_request(:post, "#{SmartsApi::Message.base_uri}disconnect")
    .to_return(:status => 200, :body => "{\"Header\":{\"SessionId\":\"487d2c44-43fe-44d3-988f-ea462af03169\"},\"Body\":null,\"ErrorInfo\":null,\"Metrics\":null,\"Success\":true,\"OperationException\":null}")


    SmartsApi::DisconnectMessage.new().send("487d2c44-43fe-44d3-988f-ea462af03169").should == "487d2c44-43fe-44d3-988f-ea462af03169"

  end

  it 'should throw an error if the connection returns an error' do

    stub_http_request(:post, "#{SmartsApi::Message.base_uri}disconnect")
    .to_return(:status => 200, :body => "{\"OperationId\":0,\"Header\":{\"SessionId\":\"00000000-0000-0000-0000-000000000000\",\"TransactionTime\":\"2012-06-22T21:02:16.642625Z\",\"Workspace\":null,\"DeploymentId\":null,\"DecisionId\":null},\"Body\":null,\"ErrorInfo\":{\"ErrorCode\":\"ServerException\",\"ErrorMessage\":\"Exception during connection\",\"Details\":[\"Invalid API access\"]},\"Metrics\":null,\"Success\":false,\"OperationException\":{\"IsRestException\":true,\"ErrorType\":\"DocApiAccessDeniedException\",\"CompleteStackTrace\":\"Type: DocApiAccessDeniedException\\r\\nMessage: Invalid API access\\r\\nStack Trace:\\r\\n   at Splog.Rest.Base.DocRestHttpHandler.VerifyHmacSignature(String method, IEnumerable`1 keys, String signature, String[] paramaters)\\r\\n   at Splog.Rest.Decisions.DocRestDecisionService.Connect(String appId, String reqTime, String userId, String pwd, String workspaceId, String reqData, String sign)\\r\\n\\r\\n\",\"ExtraInfo\":null,\"Message\":\"[DecisionServer] Exception connecting to the decision server for session 72950db0-9639-477b-b824-b82ad5122b56\",\"Data\":{}}}")

    expect{SmartsApi::DisconnectMessage.new().send("487d2c44-43fe-44d3-988f-ea462af03169")}.to raise_error(SmartsApi::Error)

  end

  it 'should throw an error if the returned sessionID is empty returns an error' do

    stub_http_request(:post, "#{SmartsApi::Message.base_uri}disconnect")
    .to_return(:status => 200, :body => "{\"OperationId\":0,\"Header\":{\"SessionId\":\"00000000-0000-0000-0000-000000000000\",\"TransactionTime\":\"2012-06-22T21:02:16.642625Z\",\"Workspace\":null,\"DeploymentId\":null,\"DecisionId\":null},\"Body\":null,\"ErrorInfo\":{\"ErrorCode\":\"ServerException\",\"ErrorMessage\":\"Exception during connection\",\"Details\":[\"Invalid API access\"]},\"Metrics\":null,\"Success\":false,\"OperationException\":{\"IsRestException\":true,\"ErrorType\":\"DocApiAccessDeniedException\",\"CompleteStackTrace\":\"Type: DocApiAccessDeniedException\\r\\nMessage: Invalid API access\\r\\nStack Trace:\\r\\n   at Splog.Rest.Base.DocRestHttpHandler.VerifyHmacSignature(String method, IEnumerable`1 keys, String signature, String[] paramaters)\\r\\n   at Splog.Rest.Decisions.DocRestDecisionService.Connect(String appId, String reqTime, String userId, String pwd, String workspaceId, String reqData, String sign)\\r\\n\\r\\n\",\"ExtraInfo\":null,\"Message\":\"[DecisionServer] Exception connecting to the decision server for session 72950db0-9639-477b-b824-b82ad5122b56\",\"Data\":{}}}")

    expect{SmartsApi::DisconnectMessage.new().send("487d2c44-43fe-44d3-988f-ea462af03169")}.to raise_error(SmartsApi::Error)

  end

  it 'should throw an error if no body is returned' do

    stub_http_request(:post, "#{SmartsApi::Message.base_uri}disconnect")
    .to_return(:status => 200)
    expect{SmartsApi::DisconnectMessage.new().send("487d2c44-43fe-44d3-988f-ea462af03169")}.to raise_error(SmartsApi::Error)

  end

  it 'should throw an error if status code is bad' do
    stub_http_request(:post, "#{SmartsApi::Message.base_uri}disconnect")
    .to_return(:status => 500)
    expect{SmartsApi::DisconnectMessage.new().send("487d2c44-43fe-44d3-988f-ea462af03169")}.to raise_error(SmartsApi::Error)

  end


end
