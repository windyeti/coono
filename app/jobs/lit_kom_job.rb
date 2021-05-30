class LitKomJob < ApplicationJob
  queue_as :default

  def perform
    Services::CreateCategoryLitKom.call
    Services::CreateProductLitKom.call
  end
end
