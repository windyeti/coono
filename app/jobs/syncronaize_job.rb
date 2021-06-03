class SyncronaizeJob < ApplicationJob
  queue_as :default

  def perform
    Services::Syncronaize.call
    data_email = {
      email: 'd.andreev@coono.com',
      subject: 'Оповещение: Закончена синхронизация Товаров с товарами поставщиков',
      body: '<strong>Закончена синхронизация Товаров с товарами поставщиков</strong>'.html_safe
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
