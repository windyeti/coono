# TODO NewDistributor
module ProductsHelper
  def distributor_exist?(product)
    true if product.lit_kom.present? || product.kovcheg.present? || product.nkamin.present?
  end
end
