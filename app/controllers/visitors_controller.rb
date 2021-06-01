class VisitorsController < ApplicationController
  def index; end
  def manual; end
  def mail_test
    data_email = {
      email: 'alohawind@mail.ru; yegor.tikhanin@gmail.com',
      subject: 'Оповещение: обновление закончено',
      body: '<strong>Здесь будет текст</strong>'.html_safe
    }
    NotificationMailer.notify(data_email).deliver_later
  end
end
