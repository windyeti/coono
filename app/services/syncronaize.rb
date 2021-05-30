class Services::Syncronaize
  def self.call
    # TODO NewDistributor
    Product.find_each(batch_size: 1000) do |product|
      lit_kom = product.lit_kom

      product.price = lit_kom&.price ? lit_kom.price.to_f - 1 : 0
      # product.quantity = "#{lit_kom&.quantity ? lit_kom.quantity : 0}".to_i
      product.save
    end
  end
end
