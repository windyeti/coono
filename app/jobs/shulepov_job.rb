class ShulepovJob < ApplicationJob
  queue_as :default

  def perform
    Services::CreateCategoryShulepov.call
    Services::CreateProductShulepov.call
    data_email = {
      email: 'coonocom@mail.ru',
      subject: 'Оповещение: Shulepov: Закончено обновление товаров поставщика',
      body: 'Shulepov: Закончено обновление товаров поставщика'
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
