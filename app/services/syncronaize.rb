class Services::Syncronaize
  def self.call
    # TODO NewDistributor
    Product.find_each(batch_size: 1000) do |product|
      price_nkamin = product.nkamin.price.to_f if product.nkamin.present? && product.nkamin.price.present?

      # вычисляем минимальную цену, если price_nkamin отсутствуюет
      unless price_nkamin
        price_lit_kom = product.lit_kom.price.to_f if product.lit_kom.present? && product.lit_kom.price.present?
        price_kovcheg = product.kovcheg.price.to_f if product.kovcheg.present? && product.kovcheg.price.present?
        price_tmf = product.tmf.price.to_f if product.tmf.present? && product.tmf.price.present?
        price_shulepov = product.shulepov.price.to_f if product.shulepov.present? && product.shulepov.price.present?
        price_realflame = product.realflame.price.to_f if product.realflame.present? && product.realflame.price.present?
        price_dim = product.dim.price.to_f if product.dim.present? && product.dim.price.present?

        min_price = [price_lit_kom, price_kovcheg, price_tmf, price_shulepov, price_realflame, price_dim].reject(&:nil?).min
      end

      product.price = price_nkamin || (min_price ? min_price - 1 : nil) || 0
      # product.quantity = "#{lit_kom&.quantity ? lit_kom.quantity : 0}".to_i
      product.save
    end
  end

end
