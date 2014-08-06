Sidekiq.configure_server do |config|
  handler = Proc.new do |ex, context_hash|
    # Boo. Rollbar doesn't allow me to add more custom data. :| ?
    Rollbar.report_exception(e)
  end
  config.error_handlers << handler
end
