class RealflameJob < ApplicationJob
  queue_as :default

  def perform
    Services::CreateCategoryRealflame.call
    Services::CreateProductRealflame.call
    data_email = {
      email: 'coonocom@mail.ru',
      subject: 'Оповещение: Realflame: Закончено обновление товаров поставщика',
      body: 'Realflame: Закончено обновление товаров поставщика'
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
