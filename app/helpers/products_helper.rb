module ProductsHelper
  def distributor_exist?(product)
    true if product.lit_kom.present?
  end
end
