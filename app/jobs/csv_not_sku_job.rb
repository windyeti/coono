class CsvNotSkuJob < ApplicationJob
  queue_as :default

  def perform
    Services::CsvNotSku.call
    data_email = {
      email: 'd.andreev@coono.com',
      subject: 'Оповещение: Создан csv c товарами без Артикула',
      body: '<strong>Создан csv c товарами без Артикула</strong>'.html_safe
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
