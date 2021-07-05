class TeplodarJob < ApplicationJob
  queue_as :default

  def perform
    Services::CreateCategoryTeplodar.call
    Services::CreateProductTeplodar.call
    data_email = {
      email: 'coonocom@mail.ru',
      subject: 'Оповещение: Teplodar: Закончено обновление товаров поставщика',
      body: 'Teplodar: Закончено обновление товаров поставщика'
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
