require 'active_support/core_ext/class'
module SmartsApi
  def self.configure(configuration = SmartsApi::Configuration.new)
    yield configuration if block_given?
    @@configuration = configuration
  end

  def self.configuration
    @@configuration ||= SmartsApi::Configuration.new
  end

  class Configuration
    cattr_accessor :logger
    cattr_accessor :user_id, :pwd, :app_id, :workspace_id, :access_key, :base_uri, :project_id
  end


  Dir[File.expand_path('../../lib/smarts_api/*.rb', __FILE__)].each {|f| require f}
  Dir[File.expand_path('../../lib/smarts_api/*/*.rb', __FILE__)].each {|f| require f}

  def self.evaluate(decision, obj, logger = nil)
    raise SmartsApi::Error.new("Object to be evaluated must define a method 'smarts_document'") unless obj.respond_to?(:smarts_document)
    logger.info "processing request for #{obj.class} id=#{obj.id}{" if logger.respond_to?(:info)

    session = SmartsApi::ConnectMessage.new().send
    response = SmartsApi::EvaluateMessage.new().
        send(session, obj, decision)

    SmartsApi::DisconnectMessage.new().send(session)
  end

end
