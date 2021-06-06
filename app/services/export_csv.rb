# require 'open-uri'

class Services::ExportCsv
  def self.call
    file = "#{Rails.root}/public/export_insales.csv"
    check = File.file?(file)
    if check.present?
      File.delete(file)
    end
    # TODO NewDistributor
    products = Product.where.not(lit_kom: nil).where.not(kovcheg: nil).order(:id)

    CSV.open("#{Rails.root}/public/export_insales.csv", "wb") do |writer|
      headers = [ 'ID варианта товара', 'Название товара', 'Артикул', 'Цена продажи' ]

      writer << headers
      products.each do |pr|
        productid_var_insales = pr.insales_var_id
        title = pr.title
        sku = pr.sku
        price = pr.price

        writer << [productid_var_insales, title, sku, price]
      end
    end #CSV.open
  end
end
