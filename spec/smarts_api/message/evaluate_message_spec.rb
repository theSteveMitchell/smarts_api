require 'spec_helper'

describe SmartsApi::EvaluateMessage do

  before (:all) do
      SmartsApi::Configuration.base_uri = "http://smarts.dev.thismashine.com/"
      SmartsApi::Configuration.access_key = "sshhhh...Secret!"
    end

    let(:obj_hash) {
    {:key => "value!!!?"}
  }

  it 'should return request body if successful' do

    body = "{\"OperationId\":1,\"Header\":{\"SessionId\":\"e3e2b012-e9b6-45e7-a96a-a009ebf0a07a\"},\"Body\":{\"Documents\":[{\"identification\":{\"actor_group\":\"root\",\"actor_id\":3,\"gender\":\"Male\",\"birth_date\":\"1984-12-08T06:00:00Z\"},\"historical_properties\":[{\"weight\":\"150\"}]}]},\"ErrorInfo\":null,\"Metrics\":null,\"Success\":true,\"OperationException\":null}"

    stub_http_request(:post, "#{SmartsApi::Configuration.base_uri}evaluate")
    .to_return(:status => 200, :body => body)
    SmartsApi::EvaluateMessage.new().send("487d2c44-43fe-44d3-988f-ea462af03169", obj_hash, "Issues Analysis Decision").should ==  {"Documents"=>
                                                                              [{"identification"=>
                                                                                 {"actor_group"=>"root",
                                                                                  "actor_id"=>3,
                                                                                  "gender"=>"Male",
                                                                                  "birth_date"=>"1984-12-08T06:00:00Z"},
                                                                                "historical_properties"=>[{"weight"=>"150"}]}]}


  end

  it 'should throw an error if the connection returns an error' do
    stub_http_request(:post, "#{SmartsApi::Configuration.base_uri}evaluate")
    .to_return(:status => 200, :body => "{\"OperationId\":0,\"Header\":{\"SessionId\":\"00000000-0000-0000-0000-000000000000\",\"TransactionTime\":\"2012-06-22T21:02:16.642625Z\",\"Workspace\":null,\"DeploymentId\":null,\"DecisionId\":null},\"Body\":null,\"ErrorInfo\":{\"ErrorCode\":\"ServerException\",\"ErrorMessage\":\"Exception during connection\",\"Details\":[\"Invalid API access\"]},\"Metrics\":null,\"Success\":false,\"OperationException\":{\"IsRestException\":true,\"ErrorType\":\"DocApiAccessDeniedException\",\"CompleteStackTrace\":\"Type: DocApiAccessDeniedException\\r\\nMessage: Invalid API access\\r\\nStack Trace:\\r\\n   at Splog.Rest.Base.DocRestHttpHandler.VerifyHmacSignature(String method, IEnumerable`1 keys, String signature, String[] paramaters)\\r\\n   at Splog.Rest.Decisions.DocRestDecisionService.Connect(String appId, String reqTime, String userId, String pwd, String workspaceId, String reqData, String sign)\\r\\n\\r\\n\",\"ExtraInfo\":null,\"Message\":\"[DecisionServer] Exception connecting to the decision server for session 72950db0-9639-477b-b824-b82ad5122b56\",\"Data\":{}}}")
    expect{SmartsApi::EvaluateMessage.new().send("487d2c44-43fe-44d3-988f-ea462af03169",obj_hash, "Issues Analysis Decision")}.to raise_error(SmartsApi::Error)

  end

  it 'should throw an error if the returned sessionID is empty returns an error' do

    stub_http_request(:post, "#{SmartsApi::Configuration.base_uri}evaluate")
    .to_return(:status => 200, :body => "{\"OperationId\":0,\"Header\":{\"SessionId\":\"00000000-0000-0000-0000-000000000000\",\"TransactionTime\":\"2012-06-22T21:02:16.642625Z\",\"Workspace\":null,\"DeploymentId\":null,\"DecisionId\":null},\"Body\":null,\"ErrorInfo\":{\"ErrorCode\":\"ServerException\",\"ErrorMessage\":\"Exception during connection\",\"Details\":[\"Invalid API access\"]},\"Metrics\":null,\"Success\":false,\"OperationException\":{\"IsRestException\":true,\"ErrorType\":\"DocApiAccessDeniedException\",\"CompleteStackTrace\":\"Type: DocApiAccessDeniedException\\r\\nMessage: Invalid API access\\r\\nStack Trace:\\r\\n   at Splog.Rest.Base.DocRestHttpHandler.VerifyHmacSignature(String method, IEnumerable`1 keys, String signature, String[] paramaters)\\r\\n   at Splog.Rest.Decisions.DocRestDecisionService.Connect(String appId, String reqTime, String userId, String pwd, String workspaceId, String reqData, String sign)\\r\\n\\r\\n\",\"ExtraInfo\":null,\"Message\":\"[DecisionServer] Exception connecting to the decision server for session 72950db0-9639-477b-b824-b82ad5122b56\",\"Data\":{}}}")
    expect{SmartsApi::EvaluateMessage.new().send("487d2c44-43fe-44d3-988f-ea462af03169",obj_hash,  "Issues Analysis Decision")}.to raise_error(SmartsApi::Error)

  end

  it 'should throw an error if no body is returned' do

    stub_http_request(:post, "#{SmartsApi::Configuration.base_uri}evaluate")
    .to_return(:status => 200)
    expect{SmartsApi::EvaluateMessage.new().send("487d2c44-43fe-44d3-988f-ea462af03169",obj_hash, "Issues Analysis Decision")}.to raise_error(SmartsApi::Error)

  end

  it 'should throw an error if status code is bad' do

    stub_http_request(:post, "#{SmartsApi::Configuration.base_uri}evaluate")
    .to_return(:status => 500)
    expect{SmartsApi::EvaluateMessage.new().send("487d2c44-43fe-44d3-988f-ea462af03169",obj_hash, "Issues Analysis Decision")}.to raise_error(SmartsApi::Error)

  end

  describe "request document" do
    it "include the input hash" do
      SmartsApi::EvaluateMessage.new().request_document("487d2c44-43fe-44d3-988f-ea462af03169", obj_hash, "Issues Analysis Decision").should ==
      "{\"OperationId\":1,\"Header\":{\"SessionId\":\"487d2c44-43fe-44d3-988f-ea462af03169\",\"DecisionId\":\"Issues Analysis Decision\"},\"Body\":{\"Documents\":{\"key\":\"value!!!?\"}}}"
    end

  end

end
