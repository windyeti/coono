class TmfJob < ApplicationJob
  queue_as :default

  def perform
    Services::CreateCategoryTmf.call
    Services::CreateProductTmf.call
    data_email = {
      email: 'd.andreev@coono.com',
      subject: 'Оповещение: Tmf: Закончено обновление товаров поставщика',
      body: 'Tmf: Закончено обновление товаров поставщика'
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
