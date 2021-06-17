class Product < ApplicationRecord
  require 'open-uri'

  # TODO NewDistributor
  belongs_to :lit_kom, optional: true
  belongs_to :kovcheg, optional: true
  belongs_to :nkamin, optional: true
  belongs_to :tmf, optional: true
  belongs_to :shulepov, optional: true
  belongs_to :realflame, optional: true

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
  end

end
