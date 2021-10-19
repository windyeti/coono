class Services::Syncronaize
  def self.call
    # TODO NewDistributor
    Product.find_each(batch_size: 1000) do |product|

      nkamin = product.nkamin
      lit_kom = product.lit_kom
      kovcheg = product.kovcheg
      tmf = product.tmf
      shulepov = product.shulepov
      realflame = product.realflame
      dim = product.dim
      sawo = product.sawo
      saunaru = product.saunaru
      teplodar = product.teplodar
      contact = product.contact
      teplomarket = product.teplomarket
      dantexgroup = product.dantexgroup
      wellfit = product.wellfit
      
      
      price_nkamin = nkamin.price.to_f if nkamin&.price.present?

      # вычисляем минимальную цену, если price_nkamin отсутствуюет
      # SAWO, Kovcheg, Dantexgroup цена без отнятия 1
      unless price_nkamin

        delta = !!product.distributor[/Fireway|FireWay/] || sawo ? 0 : 1

        price_lit_kom = lit_kom.price.to_f - delta if lit_kom&.price.present?
        price_kovcheg = kovcheg.price.to_f if kovcheg&.price.present?
        price_tmf = tmf.price.to_f - delta if tmf&.price.present?
        price_shulepov = shulepov.price.to_f - delta if shulepov&.price.present?
        price_realflame = realflame.price.to_f if realflame&.price.present?
        price_dim = dim.price.to_f if dim&.price.present?
        price_sawo = sawo.price.to_f if sawo&.price.present?
        price_saunaru = saunaru.price.to_f - delta if saunaru&.price.present?
        price_teplodar = teplodar.price.to_f - delta if teplodar&.price.present?
        price_contact = contact.price.to_f - delta if contact&.price.present?
        price_teplomarket = teplomarket.price.to_f - delta if teplomarket&.price.present? && price_saunaru.nil?
        price_dantexgroup = dantexgroup.price.to_f if dantexgroup&.price.present?

        # FITNESS
        price_wellfit = wellfit.price.to_f - delta if wellfit&.price.present?

        min_price = [price_lit_kom, price_kovcheg, price_tmf, price_shulepov, price_realflame, price_dim, price_sawo, price_saunaru, price_teplodar, price_contact, price_teplomarket, price_dantexgroup, price_wellfit].reject(&:nil?).min
      end

      product.price = price_nkamin || min_price


      # --===> Quantity <===-- #
      #
      # teplomarket - можно исключить из синхронизации, так как он учитывается только при наличии 100 у saunaru
      product.quantity =  nkamin&.quantity == "100" ||
                          saunaru&.quantity == "100" ||
                          kovcheg&.quantity == "100" ||
                          tmf&.quantity == "100" ||
                          dim&.quantity == "100" ||
                          dantexgroup&.quantity == "100" ||
                          lit_kom&.quantity == "100" ||
                          (teplomarket&.quantity == "100" && saunaru&.quantity == "100") ||
                          shulepov&.quantity == "100" ||
                          contact&.quantity == "100" ||
                          sawo&.quantity == "100" ||
                          realflame&.quantity == "100" ||
                          teplodar&.quantity == "100" ||
                          wellfit&.quantity == "100" ? 100 : 0

      product.save
    end
  end

end
