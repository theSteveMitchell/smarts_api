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

  def self.evaluate(decision, obj_hash, logger = nil)
    logger.info "processing request for #{obj_hash}" if logger.respond_to?(:info)

    session = SmartsApi::ConnectMessage.new().send
    response = SmartsApi::EvaluateMessage.new().
        send(session, obj_hash, decision)

    SmartsApi::DisconnectMessage.new().send(session)

    return response
  end

end
