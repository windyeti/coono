class Services::CreateProductLitKom
  def self.call
    # TODO сделать по-умолчанию check: true
    LitKom.all.each {|tov| tov.update(check: false, quantity: "0")}
    get_category(CategoryLitKom.first)
  end

  def self.get_category(category)
    category.subordinates.each do |subordinate|
      path_current_category = subordinate.category_path
      link = subordinate.link

      p "GUARD --> #{subordinate.parsing}"
      p subordinate.name
      next if subordinate.parsing

      get_category(subordinate)

      get_product_links(link, path_current_category)

      subordinate.update(parsing: true)
    end

    get_product_links(category.link, category.category_path) if category.name == 'Каталог'
  end

  def self.get_product_links(category_url, category_path_name)
    doc = get_doc(category_url)

    product_urls = doc.css('.ty-column3 .ty-grid-list__item form .ty-grid-list__item-name a').map {|a| a['href']}

    pagination = doc.at('.ty-pagination')

    if pagination
      number = 0
      loop do
        number += 1
        p pagianation_url = "#{category_url}page-#{number}/"
        doc_pagianation = get_doc(pagianation_url) rescue nil
        break if doc_pagianation.nil?
        product_urls += doc_pagianation.css('.ty-column3 .ty-grid-list__item form .ty-grid-list__item-name a').map {|a| a['href']}
      end
    end
    get_product(product_urls, category_path_name)
  end

  def self.get_product(product_urls, category_path_name)
    product_urls.each do |product_link|

      p "START <<<< начали собирать данные по продукту #{product_link}"
      begin
        doc = get_doc(product_link)
      rescue
        p "Нет такой страницы #{product_link}"
        next
      end
      fid = doc.at('.ty-product-block__sku label')['id'].gsub('sku_','')
      tov = LitKom.find_by(fid: fid)

      if tov.present?
        p '================ UPDATE ================'
        tov.update(check: true)
        next if tov.p4.split(' ## ').include?(category_path_name)
        update_product(tov, category_path_name)
      else
        data = {
          product_link: product_link,
          category_path_name: category_path_name
        }
        create_product(data)
      end
      p "END <<<< закончили собирать данные на продукт:: #{product_link}"
    end
    p "Total: #{LitKom.count}"
  end

  def self.update_product(tov, category_path_name)
    if tov.update(p4: "#{tov.p4} ## #{category_path_name}")
      p "---- update товара #{tov.fid} -- p4: #{tov.p4} -- всего: #{LitKom.count}}"
    else
      p "!!!!ОШИБКА UPDATE!!!!! товара #{tov.fid} -- TIME: #{Time.now}"
    end
  end

  def self.create_product(data)
    doc = get_doc(data[:product_link])

    p1 = doc.css('#content_features .ty-product-feature').map do |doc_item|
      name = doc_item.at('.ty-product-feature__label').text.strip
      value = doc_item.at('.ty-product-feature__value').text.strip
      "#{name.gsub(/:/,"")}: #{value}"
    end.join(' --- ')

    quantity = doc.at('.ty-qty-in-stock.ty-control-group__item').text.strip == 'В наличии' ? 'В наличии' : 'Ожидается'

    fid = doc.at('.ty-product-block__sku label')['id'].gsub('sku_','')
    title = doc.at('.ty-product-block-title').text.strip
    desc = doc.at('#content_description').inner_html rescue nil
    sku = doc.at('.ty-product-block__sku .ty-control-group__item').text.strip
    price = doc.at('.ty-product-block__price-actual .ty-price-num').text.strip.gsub(" ", "")
    # oldprice = data[:oldprice]

    quantity = quantity
    categories = data[:category_path_name].split('/')
    mtitle = doc.at('title').text.strip rescue nil
    mdesc = doc.at('meta[name="description"]')['content'] rescue nil
    mkeyw = doc.at('meta[name="keywords"]')['content'] rescue nil

    pp tov = LitKom.new(
      {
        fid: fid,
        sku: sku,
        title: title,
        sdesc: nil,
        desc: desc,
        price: price,
        oldprice: nil,
        pict: get_pict(doc),
        quantity: quantity,
        p1: p1,
        p4: data[:category_path_name],
        link: data[:product_link],
        cat: categories[1],
        cat1: categories[2],
        cat2: categories[3],
        cat3: categories[4],
        cat4: categories[5],
        mtitle: mtitle,
        mdesc: mdesc,
        mkeyw: mkeyw
      }
    )
    if tov.save
      pp tov
      p "+++++ создан товар #{tov.fid} -- всего: #{LitKom.count}"
    else
      p "!!!!ОШИБКА!!!!! товара #{tov.fid}"
    end
  end

  def self.get_pict(doc)
    result = []
    doc_picts = doc.css('.ty-product-thumbnails.ty-center.cm-image-gallery img')
    if doc_picts.present?
      result = doc_picts.map do |doc_pict|
        doc_pict['src'].gsub('/thumbnails/55/55', '').gsub('.png','')
      end
    elsif doc.at('.ty-product-bigpicture__img img')
      result << doc.at('.ty-product-bigpicture__img img')['src']
    end
    result.join(' ')
  end

  def self.get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  end
end
