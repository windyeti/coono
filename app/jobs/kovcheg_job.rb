class KovchegJob < ApplicationJob
  queue_as :default

  def perform
    Services::CreateCategoryKovcheg.call
    Services::CreateProductKovcheg.call
    data_email = {
      email: 'd.andreev@coono.com',
      subject: 'Оповещение: Kovcheg: Закончено обновление товаров поставщика',
      body: 'Kovcheg: Закончено обновление товаров поставщика'
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
