class SawoJob < ApplicationJob
  queue_as :default

  def perform
    Services::CreateCategorySawo.call
    Services::CreateProductSawo.call
    data_email = {
      email: 'coonocom@mail.ru',
      subject: 'Оповещение: sawo: Закончено обновление товаров поставщика',
      body: 'Sawo: Закончено обновление товаров поставщика'
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
