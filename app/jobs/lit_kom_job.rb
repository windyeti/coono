class LitKomJob < ApplicationJob
  queue_as :default

  def perform
    Services::CreateCategoryLitKom.call
    Services::CreateProductLitKom.call
    data_email = {
      email: 'coonocom@mail.ru',
      subject: 'Оповещение: Lit-kom: Закончено обновление товаров поставщика',
      body: 'Lit-kom: Закончено обновление товаров поставщика'
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
