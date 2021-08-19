class WellfitJob < ApplicationJob
  queue_as :default

  def perform
    Services::CreateCategoryWellfit.call
    Services::CreateProductWellfit.call
    data_email = {
      email: 'coonocom@mail.ru',
      subject: 'Оповещение: Wellfit: Закончено обновление товаров поставщика',
      body: 'Wellfit: Закончено обновление товаров поставщика'
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
