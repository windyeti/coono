class Services::Syncronaize
  def self.call
    # TODO NewDistributor
    Product.find_each(batch_size: 1000) do |product|
      price_lit_kom = product.lit_kom.price.to_f if product.lit_kom.present? && product.lit_kom.price.present?
      price_kovcheg = product.kovcheg.price.to_f if product.kovcheg.present? && product.kovcheg.price.present?
      price_nkamin = product.nkamin.price.to_f if product.nkamin.present? && product.nkamin.price.present?

      min_price = [price_lit_kom, price_kovcheg].reject(&:nil?).min

      # какую цену брать: минимальную минус один или из nkamin, у которой один не отнимаем
      min_price = min_price.nil? || (price_nkamin.present? && price_nkamin < min_price) ? price_nkamin : min_price - 1

      product.price = min_price.present? ? min_price : 0
      # product.quantity = "#{lit_kom&.quantity ? lit_kom.quantity : 0}".to_i
      product.save
    end
  end

end
