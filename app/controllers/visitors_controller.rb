class VisitorsController < ApplicationController
  def index; end
  def manual; end
  def mail_test
    data = {
      email: 'no-reply@coono.com',
      subject: 'Оповещение об апдейте',
      body: '<span>Здесь будет текст</span>'.html_safe
    }
    NotificationMailer.notify(data).deliver_now
    redirect_to visitors_path
  end
end
