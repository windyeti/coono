class Services::CsvNotSku
  def self.call
    file = "#{Rails.root}/public/csv_not_sku.csv"
    check = File.file?(file)
    if check.present?
      File.delete(file)
    end

    products = Product.where(sku: [nil, '']).order(:id)

    CSV.open("#{Rails.root}/public/csv_not_sku.csv", "wb") do |writer|
      headers = [ 'ID варианта товара', 'Название товара', 'Цена продажи' ]

      writer << headers
      products.each do |pr|
        productid_var_insales = pr.insales_var_id
        title = pr.title
        price = pr.price

        writer << [productid_var_insales, title, price]
      end
    end #CSV.open
  end
end
