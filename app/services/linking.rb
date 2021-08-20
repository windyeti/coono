class Services::Linking
  def self.call
    products = Product
                 .where(lit_kom: nil)
                 .or(Product.where(kovcheg: nil))
                 .or(Product.where(nkamin: nil))
                 .or(Product.where(tmf: nil))
                 .or(Product.where(shulepov: nil))
                 .or(Product.where(realflame: nil))
                 .or(Product.where(dim: nil))
                 .or(Product.where(sawo: nil))
                 .or(Product.where(saunaru: nil))
                 .or(Product.where(teplodar: nil))
                 .or(Product.where(contact: nil))
                 .or(Product.where(teplomarket: nil))
                 .or(Product.where(dantexgroup: nil))
                 .or(Product.where(wellfit: nil))
                 .order(:id)

    products.find_each do |product|

      # # Contact
      contact = Contact.find_by(sku: product.sku)
      product.update(contact: contact) if contact.present?

      # # Dim
      dantexgroup = Dantexgroup.find_by(sku: product.sku)
      product.update(dantexgroup: dantexgroup) if dantexgroup.present?

      # # Dim
      dim = Dim.find_by(sku: product.sku)
      product.update(dim: dim) if dim.present?

      # Lit-kom
      lit_kom = LitKom.find_by(sku: product.sku)
      product.update(lit_kom: lit_kom) if lit_kom.present?

      # # Kovcheg
      kovcheg = Kovcheg.find_by(sku: product.sku)
      product.update(kovcheg: kovcheg) if kovcheg.present?

      # # Nkamin
      nkamin = Nkamin.find_by(sku: product.sku)
      product.update(nkamin: nkamin) if nkamin.present?

      # # Realflame
      realflame = Realflame.find_by(sku: product.sku)
      product.update(realflame: realflame) if realflame.present?

      # # Saunaru
      saunaru = Saunaru.find_by(sku: product.sku)
      product.update(saunaru: saunaru) if saunaru.present?

      # # SAWO
      sawo = Sawo.find_by(sku: product.sku)
      product.update(sawo: sawo) if sawo.present?

      # # Shulepov
      shulepov = Shulepov.find_by(sku: product.sku)
      product.update(shulepov: shulepov) if shulepov.present?

      # # Teplodar
      teplodar = Teplodar.find_by(sku: product.sku)
      product.update(teplodar: teplodar) if teplodar.present?

      # # Teplomarket
      teplomarket = Teplomarket.find_by(sku: product.sku)
      product.update(teplomarket: teplomarket) if teplomarket.present?

      # # # Tmf
      tmf = Tmf.find_by(sku: product.sku)
      product.update(tmf: tmf) if tmf.present?

      # # # Wellfit
      wellfit = Wellfit.find_by(sku: product.sku)
      product.update(wellfit: wellfit) if wellfit.present?
    end
  end
end
