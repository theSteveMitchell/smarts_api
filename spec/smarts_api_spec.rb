require 'spec_helper'

describe SmartsApi do

  describe "evaluate" do

    before (:all) do
      SmartsApi::Message.base_uri = "http://smarts.dev.thismashine.com"
      SmartsApi::Message.access_key = "sshhhh...Secret!"
    end

    describe "expectations on eval object" do

      it 'should raise error and not call connect if obj is nil' do
        expect{SmartsApi.evaluate(
        "string", nil
        )}.to raise_error(SmartsApi::Error, "Object to be evaluated must define a method 'smarts_document'")
      end

      it 'should raise error and not call connect if obj does not define the document method' do
        RegularClass = Class.new() {}
        instance = RegularClass.new
        instance.should_not be_nil
        expect{SmartsApi.evaluate(
        "string", instance
        )}.to raise_error(SmartsApi::Error, "Object to be evaluated must define a method 'smarts_document'")
      end

      it 'should accept any object that defines the document method' do
        EvalClass= Class.new() do
          def smarts_document
            "EvalClass.Instance 1"
          end
        end

        instance = EvalClass.new
        instance.should_not be_nil

        SmartsApi::ConnectMessage.any_instance.should_receive(:send).and_return("session 334")
        SmartsApi::EvaluateMessage.any_instance.should_receive(:send)
        SmartsApi.evaluate("string", instance)
      end
    end

    describe "specifying decision string" do
      it "should include the decision name when sending the evaluate message" do

        instance = EvalClass.new
        instance.should_not be_nil
        SmartsApi::ConnectMessage.any_instance.should_receive(:send).and_return("session 3339")
        SmartsApi::EvaluateMessage.any_instance.should_receive(:send).with("session 3339", instance, "Chosen_decision")
         #SmartsApi::EvaluateMessage.any_instance.should_receive(:send)
        #SmartsApi::DisconnectMessage.should_receive(:send)
         SmartsApi.evaluate("Chosen_decision", instance)
      end
    end
  end


end
