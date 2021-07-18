# TODO NewDistributor
module ProductsHelper
  def distributor_exist?(product)
    true if product.lit_kom.present? ||
      product.kovcheg.present? ||
      product.nkamin.present? ||
      product.tmf.present? ||
      product.shulepov.present? ||
      product.realflame.present? ||
      product.dim.present? ||
      product.sawo.present? ||
      product.saunaru.present? ||
      product.teplodar.present? ||
      product.contact.present? ||
      product.teplomarket.present?
  end
end
