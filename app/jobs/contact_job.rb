class ContactJob < ApplicationJob
  queue_as :default

  def perform
    Services::CreateCategoryContact.call
    Services::CreateProductContact.call
    data_email = {
      email: 'coonocom@mail.ru',
      subject: 'Оповещение: ContactPlus: Закончено обновление товаров поставщика',
      body: 'ContactPlus: Закончено обновление товаров поставщика'
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
