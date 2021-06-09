class NkaminJob < ApplicationJob
  queue_as :default

  def perform
    Services::CreateCategoryNkamin.call
    # Services::CreateProductNkamin.call
    data_email = {
      email: 'd.andreev@coono.com',
      subject: 'Оповещение: Nkamin: Закончено обновление товаров поставщика',
      body: 'Nkamin: Закончено обновление товаров поставщика'
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
