class HardJob < ApplicationJob
  queue_as :default

  def perform
    Services::ImportInsalesXml.call
    Services::CreateCategoryLitKom.call
    Services::CreateProductLitKom.call
    Services::ExportCsv.call

    # ActionCable.server.broadcast 'finish_process', {process_name: "Обновление Цен и Остатков Товаров"}
  end
end
