class NotificationMailer < ApplicationMailer
  default from: 'no-reply@coono.com'
  layout 'notification_mailer'

  def notify(data)
    @email = data[:email]
    @subject = data[:subject]
    @body = data[:body]

    mail(to: @email, subject: @subject, bcc: ["yegor.tikhanin@gmail.com"])
  end
end
