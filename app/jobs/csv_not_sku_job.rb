class CsvNotSkuJob < ApplicationJob
  queue_as :default

  def perform
    Services::CsvNotSku.call
    data_email = {
      email: 'coonocom@mail.ru',
      subject: 'Оповещение: Создан csv c товарами без Артикула',
      body: 'Создан csv c товарами без Артикула'
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
