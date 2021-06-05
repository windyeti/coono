class ProductImportInsalesXmlJob < ApplicationJob
  queue_as :default

  def perform
    Services::ImportInsalesXml.call
    data_email = {
      email: 'd.andreev@coono.com',
      subject: 'Оповещение: Закончено обновление Товаров',
      body: 'Закончено обновление Товаров'
    }
    NotificationMailer.notify(data_email).deliver_later
    # ActionCable.server.broadcast 'finish_process', {process_name: "Обновление Товаров InSales"}
  end
end
