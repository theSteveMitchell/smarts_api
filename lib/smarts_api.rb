
module SmartsApi
  Dir[File.expand_path('../../lib/smarts_api/*.rb', __FILE__)].each {|f| require f}
  Dir[File.expand_path('../../lib/smarts_api/*/*.rb', __FILE__)].each {|f| require f}

  def self.evaluate(decision, obj, logger = nil)
    raise SmartsApi::Error.new("Object to be evaluated must define a method 'smarts_document'") unless obj.respond_to?(:smarts_document)
    logger.info "processing request for #{obj}" if logger.respond_to?(:info)

    session = SmartsApi::ConnectMessage.new(logger).send
    response = SmartsApi::EvaluateMessage.new(logger).
        send(session, obj, decision)

    #SmartsApi::DisconnectMessage.new(logger).disconnect(session)
  end

end
