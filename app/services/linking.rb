class Services::Linking
  def self.call
    Product.find_each do |product|
      kovcheg = Kovcheg.find_by(sku: product.sku)
      product.update(kovcheg: kovcheg) if kovcheg.present?
    end
  end
end
