class Services::Linking
  def self.call
    Product.find_each do |product|

      # # Contact
      contact = Contact.find_by(sku: product.sku)
      product.update(contact: contact) if contact.present?

      # # Dim
      dim = Dim.find_by(sku: product.sku)
      product.update(dim: dim) if dim.present?

      # # Lit-kom
      # lit_kom = LitKom.find_by(sku: product.sku)
      # product.update(lit_kom: lit_kom) if lit_kom.present?
      #
      # # # Kovcheg
      # kovcheg = Kovcheg.find_by(sku: product.sku)
      # product.update(kovcheg: kovcheg) if kovcheg.present?

      # # Nkamin
      nkamin = Nkamin.find_by(sku: product.sku)
      product.update(nkamin: nkamin) if nkamin.present?

      # # Realflame
      realflame = Realflame.find_by(sku: product.sku)
      product.update(realflame: realflame) if realflame.present?

      # # Saunaru
      saunaru = Saunaru.find_by(sku: product.sku)
      product.update(saunaru: saunaru) if saunaru.present?

      # # # SAWO
      # sawo = Sawo.find_by(sku: product.sku)
      # product.update(sawo: sawo) if sawo.present?

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
    end
  end
end
