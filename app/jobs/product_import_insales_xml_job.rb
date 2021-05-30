class ProductImportInsalesXmlJob < ApplicationJob
  queue_as :default

  def perform
    Services::ImportInsalesXml.call

    # ActionCable.server.broadcast 'finish_process', {process_name: "Обновление Товаров InSales"}
  end
end
