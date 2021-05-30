class Product < ApplicationRecord
  require 'open-uri'

  # TODO NewDistributor
  belongs_to :lit_kom, optional: true

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
        errors.add(:lit_kom_id, "Товар поставщика не существует или он уже связан с другим товаром")
      end
    end

    # if dr_id.present?
    #   dr = Dr.find_by(id: dr_id)
    #   if dr.nil? || (dr.product.present? && dr.product != self)
    #     errors.add(:dr_id, "Товар поставщика не существует или он уже связан с другим товаром")
    #   end
    # end
  end

  def self.import_insales_xml
    puts '=====>>>> СТАРТ InSales YML '+Time.now.to_s
    uri = "https://demo-themes.myinsales.ru/marketplace/76801.xml"
    response = RestClient.get uri, :accept => :xml, :content_type => "application/xml"
    data = Nokogiri::XML(response)
    mypr = data.xpath("//offer")

    categories = {}
    doc_category = data.xpath("//category")

    doc_category.each do |c|
      categories[c["id"]] = c.text
    end


    mypr.each do |pr|
    params = {}
    pr.xpath("param").each do |p|
      params[p['name']] = p.text
    end

      data_create = {
        sku: pr.xpath("vendorCode").text,
        title: pr.xpath("model").text,
        url: pr.xpath("url").text,
        desc: pr.xpath("description").text,
        image: pr.xpath("picture").map(&:text).join(' '),
        cat: categories[pr.xpath("categoryId").text],
        price: pr.xpath("price").text.to_f,
        oldprice: pr.xpath("oldprice").text.to_f,
        weight: pr.xpath("weight").text,
        color: params['Цвет'],
        size: params['Размер'],
        distributor: params['Поставщик'],
        insales_id: pr["group_id"],
        insales_var_id: pr["id"]
      }

      data_update = {
        title: pr.xpath("model").text,
        url: pr.xpath("url").text,
        desc: pr.xpath("description").text,
        image: pr.xpath("picture").map(&:text).join(' '),
        cat: categories[pr.xpath("categoryId").text],
        price: pr.xpath("price").text.to_f,
        oldprice: pr.xpath("oldprice").text.to_f,
        weight: pr.xpath("weight").text,
        color: params['Цвет'],
        size: params['Размер'],
        distributor: params['Поставщик']
      }
      product = Product
                  .find_by(insales_var_id: data_create[:insales_var_id])

      product.present? ? product.update_attributes(data_update) : Product.create(data_create)
    end
    puts '=====>>>> FINISH InSales YML '+Time.now.to_s
  end

end
