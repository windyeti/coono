class VisitorsController < ApplicationController
  def index; end
  def manual; end
  def mail_test
    data_email = {
      email: 'alohawind@mail.ru',
      subject: 'Оповещение: обновление закончено',
      body: '<strong>Здесь будет текст</strong>'.html_safe
    }
    NotificationMailer.notify(data_email).deliver_later
    redirect_to visitors_path
  end
end
