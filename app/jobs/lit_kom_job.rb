class LitKomJob < ApplicationJob
  queue_as :default

  def perform
    Services::CreateCategoryLitKom.call
    Services::CreateProductLitKom.call
    data_email = {
      email: 'd.andreev@coono.com',
      subject: 'Оповещение: Lit-kom: Закончено обновление товаров поставщика',
      body: '<strong>Lit-kom: Закончено обновление товаров поставщика</strong>'.html_safe
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
