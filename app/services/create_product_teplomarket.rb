class Services::CreateProductTeplomarket
  def self.call
    Teplomarket.all.each {|tov| tov.update(check: false, quantity: "0")}
    get_category(CategoryTeplomarket.first)
  end

  def self.get_category(category)
    p "GUARD --> #{category.parsing}"
    p category.name
    return if category.parsing

    category.subordinates.each do |subordinate|
      get_category(subordinate)
    end

    get_product_links(category.link, category.category_path)
    # category.update(parsing: true)
  end

  def self.get_product_links(category_url, category_path_name)
    doc = get_doc(category_url)

    product_urls = doc.css('.products__line .products__line-desc .products__line-title').map {|a| a['href']}

    doc_pagination = doc.css('.pagination li a')

    page = 1
    if doc_pagination.size > 0
      loop do
        page += 1
        pagianation_url = "#{category_url}?page=#{page}"
        doc_pagianation = get_doc(pagianation_url)
        pagination_product_urls = doc_pagianation.css('.products__line .products__line-desc .products__line-title').map {|a| a['href']}
        break if pagination_product_urls.size == 0
        product_urls += pagination_product_urls
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

      # fid = doc.at('.sku__action-buttons a')['data-for']
      title = doc.at('.product-title-row h1').text.strip rescue nil

      tov = Teplomarket.find_by(title: title)

      sku = doc.at('.sku__id').text.gsub(/Артикул: /,"").strip rescue nil

      p1 = get_p1(doc)

      pict = get_pict(doc)

      quantity = doc.at('.sku__status').text.strip rescue nil

      desc = doc.css('.details .tabdescription').inner_html rescue nil
      price = doc.at('.sku__price .special-price') ? doc.at('.sku__price .special-price').text.strip.gsub(/₽|\s| /, "") : doc.at('.sku__price').text.strip.gsub(/₽|\s| /, "")
      oldprice = nil
      link = product_link
      p4 = category_path_name

      categories = category_path_name.split('/')
      mtitle = doc.at('title').text.strip rescue nil
      mdesc = doc.at('meta[name="description"]')['content'] rescue nil
      mkeyw = doc.at('meta[name="keywords"]')['content'] rescue nil

      pp data = {
        fid: title,
        sku: sku,
        title: title,
        sdesc: nil,
        desc: desc,
        price: price,
        oldprice: oldprice,
        pict: pict,
        quantity: quantity,
        p1: p1,
        p4: p4,
        link: link,
        cat: categories[1],
        cat1: categories[2],
        cat2: categories[3],
        cat3: categories[4],
        cat4: categories[5],
        mtitle: mtitle,
        mdesc: mdesc,
        mkeyw: mkeyw
      }

      if tov.present?
        p '================ UPDATE ================'
        update_product(tov, data)
      else
        create_product(data)
      end
      "END <<<< закончили собирать данные на продукт:: #{product_link}"
    end
    p "Total: #{Teplomarket.count}"
  end

  def self.update_product(tov, data)
    if tov.check
      return if tov.p4.split(' ## ').include?(data[:p4])
      if tov.update(p4: "#{tov.p4} ## #{data[:p4]}")
        p "---- update товара только p4 #{tov.fid} -- p4: #{tov.p4} -- всего: #{Teplomarket.count}}"
      else
        p "!!!!ОШИБКА UPDATE!!!!! товара #{tov.fid} -- TIME: #{Time.now}"
      end
    else
      tov.update(check: true)
      tov.update(data)
      p ">>>>>> update товара #{tov.fid} -- p4: #{tov.p4} -- всего: #{Teplomarket.count}}"
    end
  end

  def self.create_product(data)
    pp tov = Teplomarket.new(data)
    if tov.save
      pp tov
      p "+++++ создан товар #{tov.fid} -- всего: #{Teplomarket.count}"
    else
      p "!!!!ОШИБКА!!!!! товара #{tov.fid}"
    end
  end

  def self.get_pict(doc)
    result = []
    doc_picts = doc.css('.sku__gallery a')
    if doc_picts.present?
      result = doc_picts.map do |doc_pict|
        doc_pict['href']
      end
    else
      nil
    end
    result.join(' ')
  end

  def self.get_p1(doc)
    doc_dts = doc.css('.details div.tabattribute .details__info-dl dt')
    doc_dds = doc.css('.details div.tabattribute .details__info-dl dd')
    result = []
    doc_dts.each_with_index do |doc_dt, index|
      result << "#{doc_dt.text.strip}: #{doc_dds[index].text.strip}"
    end
    result.join(' --- ')
  end

  def self.get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  end
end
