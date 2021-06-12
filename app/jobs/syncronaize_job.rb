class SyncronaizeJob < ApplicationJob
  queue_as :default

  def perform
    Services::Syncronaize.call
    data_email = {
      email: 'coonocom@mail.ru',
      subject: 'Оповещение: Закончена синхронизация Товаров с товарами поставщиков',
      body: 'Закончена синхронизация Товаров с товарами поставщиков'
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
