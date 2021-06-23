class DimJob < ApplicationJob
  queue_as :default

  def perform
    Services::CreateCategoryDim.call
    Services::CreateProductDim.call
    data_email = {
      email: 'coonocom@mail.ru',
      subject: 'Оповещение: Dimplex: Закончено обновление товаров поставщика',
      body: 'Dimplex: Закончено обновление товаров поставщика'
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
