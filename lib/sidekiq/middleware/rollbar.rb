class Sidekiq::Middlewar::Rollbar
  def call(worker, msg, queue)
    begin
      yield
    rescue Exception => e
      # Boo. Rollbar doesn't allow me to add more custom data. :| ?
      Rollbar.report_exception(e)
    end
  end
end
