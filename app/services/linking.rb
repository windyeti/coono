class Services::Linking
  def self.call
    Product.find_each do |product|

      # Lit-kom
      lit_kom = LitKom.find_by(sku: product.sku)
      product.update(lit_kom: lit_kom) if lit_kom.present?

      # # Kovcheg
      kovcheg = Kovcheg.find_by(sku: product.sku)
      product.update(kovcheg: kovcheg) if kovcheg.present?
    end
  end
end
