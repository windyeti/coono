class CsvNotSkuJob < ApplicationJob
  queue_as :default

  def perform
    Services::CsvNotSku.call
  end
end
