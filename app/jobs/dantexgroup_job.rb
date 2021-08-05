class DantexgroupJob < ApplicationJob
  queue_as :default

  def perform
    Services::CreateCategoryDantexgroup.call
    Services::CreateProductDantexgroup.call
    data_email = {
      email: 'coonocom@mail.ru',
      subject: 'Оповещение: Dantexgroup: Закончено обновление товаров поставщика',
      body: 'Dantexgroup: Закончено обновление товаров поставщика'
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
