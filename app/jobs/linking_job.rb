class LinkingJob < ApplicationJob
  queue_as :default

  def perform
    Services::Linking.call

    data_email = {
      email: 'd.andreev@coono.com',
      subject: 'Оповещение: Linking',
      body: 'linking: Закончено'
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
