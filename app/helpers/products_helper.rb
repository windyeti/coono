module ProductsHelper
  def selected(product)
    providers = Provider.all.order(:id)
    providers.each do |provider|
      return provider.permalink if provider.permalink == product.productable_type
    end
  end

  # TODO NewDistributor
  def distributor_product_id_quantity(product)
    result = {
      available: false,
      html: ''
    }
    result[:available] = true if product.lit_kom

    result[:html] += "<p>Lit-kom: ID: <a href=/lit_koms?q%5Bid_eq%5D=#{product.lit_kom.id}>#{product.lit_kom.id}</a>, остаток: #{product.lit_kom.quantity}, цена: #{product.lit_kom.price}</p>" if product.lit_kom.present?
    result
  end
end
