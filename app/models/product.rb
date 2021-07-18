class Product < ApplicationRecord
  require 'open-uri'

  # TODO NewDistributor
  DISTRIBUTOR = [
    ["lit_kom_id_not_null", "Lit-kom"],
    ["kovcheg_id_not_null", "Kovcheg"],
    ["nkamin_id_not_null", "Nkamin"],
    ["tmf_id_not_null", "Tmf"],
    ["shulepov_id_not_null", "Shulepov"],
    ["realflame_id_not_null", "Realflame"],
    ["dim_id_not_null", "Dimplex"],
    ["sawo_id_not_null", "Sawo"],
    ["saunaru_id_not_null", "Saunaru"],
    ["teplodar_id_not_null", "Teplodar"],
    ["teplomarket_id_not_null", "TeplomarketPlus"],
    ["teplomarket_id_not_null", "Teplomarket-m"],
    ["lit_kom_id_and_kovcheg_id_and_nkamin_id_and_tmf_id_and_shulepov_id_and_realflame_id_and_dim_id_and_sawo_id_and_saunaru_id_and_teplodar_id_and_teplomarket_id_and_teplomarket_id_null", "Unsync"],
    ["lit_kom_id_or_kovcheg_id_or_nkamin_id_or_tmf_id_or_shulepov_id_or_realflame_id_or_dim_id_or_sawo_id_or_saunaru_id_or_teplodar_id_or_teplomarket_id_or_teplomarket_id_not_null", "Sync"],
  ]

  # TODO NewDistributor
  belongs_to :lit_kom, optional: true
  belongs_to :kovcheg, optional: true
  belongs_to :nkamin, optional: true
  belongs_to :tmf, optional: true
  belongs_to :shulepov, optional: true
  belongs_to :realflame, optional: true
  belongs_to :dim, optional: true
  belongs_to :sawo, optional: true
  belongs_to :saunaru, optional: true
  belongs_to :teplodar, optional: true
  belongs_to :contact, optional: true
  belongs_to :teplomarket, optional: true

  scope :product_all_size, -> { order(:id).size }
  scope :product_qt_not_null, -> { where('quantity > 0') }
  scope :product_qt_not_null_size, -> { where('quantity > 0').size }
  scope :product_cat, -> { order('cat DESC').select(:cat).uniq }
  scope :product_image_nil, -> { where(image: [nil, '']).order(:id) }

  # TODO NewDistributor
  validate :new_distributor_empty, on: :update

  def new_distributor_empty
    if lit_kom_id.present?
      lit_kom = LitKom.find_by(id: lit_kom_id)
      if lit_kom.nil? || (lit_kom.product.present? && lit_kom.product != self)
        errors.add(:lit_kom_id, "Товар поставщика Lit-kom не существует или он уже связан с другим товаром")
      end
    end
    if kovcheg_id.present?
      kovcheg = Kovcheg.find_by(id: kovcheg_id)
      if kovcheg.nil? || (kovcheg.product.present? && kovcheg.product != self)
        errors.add(:kovcheg_id, "Товар поставщика Kovcheg не существует или он уже связан с другим товаром")
      end
    end
    if nkamin_id.present?
      nkamin = Nkamin.find_by(id: nkamin_id)
      if nkamin.nil? || (nkamin.product.present? && nkamin.product != self)
        errors.add(:nkamin_id, "Товар поставщика Nkamin не существует или он уже связан с другим товаром")
      end
    end
    if tmf_id.present?
      tmf = Tmf.find_by(id: tmf_id)
      if tmf.nil? || (tmf.product.present? && tmf.product != self)
        errors.add(:tmf_id, "Товар поставщика Tmf не существует или он уже связан с другим товаром")
      end
    end
    if shulepov_id.present?
      shulepov = Shulepov.find_by(id: shulepov_id)
      if shulepov.nil? || (shulepov.product.present? && shulepov.product != self)
        errors.add(:shulepov_id, "Товар поставщика Shulepov не существует или он уже связан с другим товаром")
      end
    end
    if realflame_id.present?
      realflame = Realflame.find_by(id: realflame_id)
      if realflame.nil? || (realflame.product.present? && realflame.product != self)
        errors.add(:realflame_id, "Товар поставщика Realflame не существует или он уже связан с другим товаром")
      end
    end
    if dim_id.present?
      dim = Dim.find_by(id: dim_id)
      if dim.nil? || (dim.product.present? && dim.product != self)
        errors.add(:dim_id, "Товар поставщика Dim не существует или он уже связан с другим товаром")
      end
    end
    if sawo_id.present?
      sawo = Sawo.find_by(id: sawo_id)
      if sawo.nil? || (sawo.product.present? && sawo.product != self)
        errors.add(:sawo_id, "Товар поставщика Sawo не существует или он уже связан с другим товаром")
      end
    end
    if saunaru_id.present?
      saunaru = Saunaru.find_by(id: saunaru_id)
      if saunaru.nil? || (saunaru.product.present? && saunaru.product != self)
        errors.add(:saunaru_id, "Товар поставщика Saunaru не существует или он уже связан с другим товаром")
      end
    end
    if teplodar_id.present?
      teplodar = Teplodar.find_by(id: teplodar_id)
      if teplodar.nil? || (teplodar.product.present? && teplodar.product != self)
        errors.add(:teplodar_id, "Товар поставщика Teplodar не существует или он уже связан с другим товаром")
      end
    end
    if teplomarket_id.present?
      teplomarket = Teplomarket.find_by(id: teplomarket_id)
      if teplomarket.nil? || (teplomarket.product.present? && teplomarket.product != self)
        errors.add(:teplomarket_id, "Товар поставщика Teplomarket не существует или он уже связан с другим товаром")
      end
    end
    if teplomarket_id.present?
      teplomarket = Teplomarket.find_by(id: teplomarket_id)
      if teplomarket.nil? || (teplomarket.product.present? && teplomarket.product != self)
        errors.add(:teplomarket_id, "Товар поставщика Teplomarket не существует или он уже связан с другим товаром")
      end
    end
  end

end
