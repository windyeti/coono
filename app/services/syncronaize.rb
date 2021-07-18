class Services::Syncronaize
  def self.call
    # TODO NewDistributor
    Product.find_each(batch_size: 1000) do |product|
      price_nkamin = product.nkamin.price.to_f if product.nkamin.present? && product.nkamin.price.present?

      # вычисляем минимальную цену, если price_nkamin отсутствуюет
      # SAWO цена без отнятия 1
      unless price_nkamin

        delta = !!product.distributor[/Fireway|FireWay/] ? 0 : 1

        price_lit_kom = product.lit_kom.price.to_f - delta if product.lit_kom.present? && product.lit_kom.price.present?
        price_kovcheg = product.kovcheg.price.to_f - delta if product.kovcheg.present? && product.kovcheg.price.present?
        price_tmf = product.tmf.price.to_f - delta if product.tmf.present? && product.tmf.price.present?
        price_shulepov = product.shulepov.price.to_f - delta if product.shulepov.present? && product.shulepov.price.present?
        price_realflame = product.realflame.price.to_f - delta if product.realflame.present? && product.realflame.price.present?
        price_dim = product.dim.price.to_f - delta if product.dim.present? && product.dim.price.present?
        price_sawo = product.sawo.price.to_f if product.sawo.present? && product.sawo.price.present?
        price_saunaru = product.saunaru.price.to_f - delta if product.saunaru.present? && product.saunaru.price.present?
        price_teplodar = product.teplodar.price.to_f - delta if product.teplodar.present? && product.teplodar.price.present?
        price_contact = product.contact.price.to_f - delta if product.contact.present? && product.contact.price.present?
        price_teplomarket = product.teplomarket.price.to_f - delta if product.teplomarket.present? && product.teplomarket.price.present?

        min_price = [price_lit_kom, price_kovcheg, price_tmf, price_shulepov, price_realflame, price_dim, price_sawo, price_saunaru, price_teplodar, price_contact, price_teplomarket].reject(&:nil?).min
      end

      product.price = price_nkamin || min_price
      # product.quantity = "#{lit_kom&.quantity ? lit_kom.quantity : 0}".to_i
      product.save
    end
  end

end
