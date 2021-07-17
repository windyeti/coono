class TeplomarketJob < ApplicationJob
  queue_as :default

  def perform
    Services::CreateCategoryTeplomarket.call
    Services::CreateProductTeplomarket.call
    data_email = {
      email: 'coonocom@mail.ru',
      subject: 'Оповещение: Teplomarket: Закончено обновление товаров поставщика',
      body: 'Teplomarket: Закончено обновление товаров поставщика'
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
