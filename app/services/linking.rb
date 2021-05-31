class Services::Linking
  def self.call
    Product.find_each do |product|
      lit_kom = LitKom.find_by(sku: product.sku)
      product.update(lit_kom: lit_kom) if lit_kom.present?
    end
  end
end
