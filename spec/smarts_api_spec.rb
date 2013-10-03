require 'spec_helper'

describe SmartsApi do

  describe "evaluate" do

    before (:all) do
      SmartsApi::Configuration.base_uri = "http://smarts.dev.thismashine.com/"
      SmartsApi::Configuration.access_key = "sshhhh...Secret!"
    end

    describe "expectations on eval object" do
      it 'should accept any hash as a ' do

        hash = {:hash? => true}

        SmartsApi::ConnectMessage.any_instance.should_receive(:send).and_return("session 334")
        SmartsApi::EvaluateMessage.any_instance.should_receive(:send)
        SmartsApi::DisconnectMessage.any_instance.should_receive(:send).with("session 334")
        SmartsApi.evaluate("string", hash)
      end
    end

    describe "specifying decision string" do
      it "should include the decision name and session when sending the evaluate message" do

        hash = {:hash? => true}
        SmartsApi::ConnectMessage.any_instance.should_receive(:send).and_return("session 3339")
        SmartsApi::EvaluateMessage.any_instance.should_receive(:send).with("session 3339", hash, "Chosen_decision")
        SmartsApi::DisconnectMessage.any_instance.should_receive(:send).with("session 3339")

        SmartsApi.evaluate("Chosen_decision", hash)
      end
    end
  end


end
