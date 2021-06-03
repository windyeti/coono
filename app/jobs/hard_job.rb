class HardJob < ApplicationJob
  queue_as :default

  def perform
    Services::ImportInsalesXml.call
    Services::CreateCategoryLitKom.call
    Services::CreateProductLitKom.call
    Services::ExportCsv.call
    data_email = {
      email: 'd.andreev@coono.com',
      subject: 'Оповещение: Закончен полный цикл обновления-синхронизации-создания товаров для импорта',
      body: '<strong>Закончен полный цикл обновления-синхронизации-создания товаров для импорта</strong>'.html_safe
    }
    NotificationMailer.notify(data_email).deliver_later

    # ActionCable.server.broadcast 'finish_process', {process_name: "Обновление Цен и Остатков Товаров"}
  end
end
