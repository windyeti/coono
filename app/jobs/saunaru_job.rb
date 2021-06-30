class SaunaruJob < ApplicationJob
  queue_as :default

  def perform
    Services::CreateCategorySaunaru.call
    Services::CreateProductSaunaru.call
    data_email = {
      email: 'coonocom@mail.ru',
      subject: 'Оповещение: Saunaru: Закончено обновление товаров поставщика',
      body: 'Saunaru: Закончено обновление товаров поставщика'
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
