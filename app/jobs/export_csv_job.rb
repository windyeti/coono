class ExportCsvJob < ApplicationJob
  queue_as :default

  def perform
    Services::ExportCsv.call
    data_email = {
      email: 'd.andreev@coono.com',
      subject: 'Оповещение: Создан csv c товарами для импорта в InSales',
      body: '<strong>Создан csv c товарами для импорта в InSales</strong>'.html_safe
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
