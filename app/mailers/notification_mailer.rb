class NotificationMailer < ApplicationMailer
  default from: 'no-replay@conoo_integration.com'
  layout 'notification_mailer'

  def notify(data)
    @email = data[:email]
    @subject = data[:subject]
    @body = data[:body]

    mail to: @email, subject: @subject
  end
end
