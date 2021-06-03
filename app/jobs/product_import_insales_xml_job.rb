class ProductImportInsalesXmlJob < ApplicationJob
  queue_as :default

  def perform
    Services::ImportInsalesXml.call
    data_email = {
      email: 'd.andreev@coono.com',
      subject: 'Оповещение: Закончено обновление Товаров',
      body: '<strong>Закончено обновление Товаров</strong>'.html_safe
    }
    NotificationMailer.notify(data_email).deliver_later
    # ActionCable.server.broadcast 'finish_process', {process_name: "Обновление Товаров InSales"}
  end
end
