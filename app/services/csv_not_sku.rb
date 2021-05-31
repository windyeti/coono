class Services::CsvNotSku
  def self.call
    file = "#{Rails.root}/public/csv_not_sku.csv"
    check = File.file?(file)
    if check.present?
      File.delete(file)
    end

    products = Product.where(sku: [nil, '']).order(:id)

    CSV.open("#{Rails.root}/public/csv_not_sku.csv", "wb") do |writer|
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
