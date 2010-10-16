class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "[#{message.to}] #{message.subject}"
    message.to = "tua_mail@gmail.com"
  end
end
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
