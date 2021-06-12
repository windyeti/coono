class NkaminJob < ApplicationJob
  queue_as :default

  def perform
    category = Services::CreateCategoryNkamin.call
    Services::CreateProductNkamin.call(category)
    data_email = {
      email: 'coonocom@mail.ru',
      subject: 'Оповещение: Nkamin: Закончено обновление товаров поставщика',
      body: 'Nkamin: Закончено обновление товаров поставщика'
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
