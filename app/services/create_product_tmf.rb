class Services::CreateProductTmf
  def self.call
    Tmf.all.each {|tov| tov.update(check: false, quantity: "0")}
    get_category(CategoryTmf.first)
  end

  def self.get_category(category)
    p "GUARD --> #{category.parsing}"
    p category.name
    return if category.parsing

    category.subordinates.each do |subordinate|
      get_category(subordinate)
    end

    get_product_links(category.link, category.category_path)
    category.update(parsing: true)
  end

  def self.get_product_links(category_url, category_path_name)
    doc = get_doc(category_url)

    product_urls = doc.css('.catalog_item_wrapp .item-title a').map {|a| "https://t-m-f.ru#{a['href']}"}

    doc_pagination = doc.css('.module-pagination .nums a')

    if doc_pagination.size > 0
      number = doc_pagination.last.text.strip.to_i

      page = 1
      (2..number).each do
        page += 1
        pagianation_url = "#{category_url}?PAGEN_1=#{page}"
        doc_pagianation = get_doc(pagianation_url)
        product_urls += doc_pagianation.css('.catalog_item_wrapp .item-title a').map {|a| "https://t-m-f.ru#{a['href']}"}
      end
    end
    get_product(product_urls, category_path_name)
  end

  def self.get_product(product_urls, category_path_name)
    product_urls.each do |product_link|

    get_product_data(product_link, category_path_name)

    skus_links = get_sku(product_link)
    if skus_links.present?
      skus_links.each do |sku_link|
        get_product_data(sku_link, category_path_name, false)
      end
    end
    end
    p "Total: #{Tmf.count}"
  end

  def self.get_product_data(product_link, category_path_name, main_product = true)
    p "START <<<< начали собирать данные по продукту #{product_link}"
    begin
      doc = rest_client_get(product_link)
    rescue
      p "Нет такой страницы #{product_link}"
      return
    end

    fid = doc.at('meta[itemprop="sku"]')['content']

    tov = Tmf.find_by(fid: fid)

    if main_product
      desc = doc.at('.tabs_section .current').inner_html rescue nil
      sdesc = doc.at('.advantage').inner_html rescue nil

      p1 = doc.css('.tabs_section .specifications tr').map do |doc_item|
        tds = doc_item.css('td')
        name = tds[0].text.strip
        value = tds[1].text.strip
        "#{name}: #{value}"
      end.join(' --- ')
      sku = nil
      price = doc.css('.price').text.gsub(/[а-яА-Я]|\*|\.|\s|₽|^0+/, "").strip rescue nil
      pict = get_pict_main(doc)
      quantity = nil
    else
      desc = nil
      sdesc = nil

      p1 = doc.css('.mod_content .right tr').map do |doc_item|
        tds = doc_item.css('td')
        name = tds[0].text.strip
        value = tds[1].text.strip
        "#{name}: #{value}"
      end.join(' --- ')
      sku = doc.at('.top-part .right').text.strip.gsub("Артикул: ", "") rescue nil
      price = doc.css('.price').text.gsub(/[а-яА-Я]|\*|\.|\s|₽|^0+/, "").strip rescue nil
      pict = get_pict_vars(doc)
      quantity = nil
    end

    title = doc.at('#pagetitle').text.strip rescue nil

    link = product_link
    p4 = category_path_name

    categories = category_path_name.split('/')
    mtitle = doc.at('title').text.strip rescue nil
    mdesc = doc.at('meta[name="description"]')['content'] rescue nil
    mkeyw = doc.at('meta[name="keywords"]')['content'] rescue nil

    pp data = {
      fid: fid,
      sku: sku,
      title: title,
      sdesc: sdesc,
      desc: desc,
      price: price,
      oldprice: nil,
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

  def self.get_sku(product_link)
    p "START <<<< начали собирать данные по ВАРИАНТУ #{product_link}"
    begin
      doc = rest_client_get(product_link)
    rescue
      p "Нет такой страницы #{product_link}"
      return
    end
    vars_links = doc.css(".tabs_section .tabs_content.tabs-body .modification").css(" a").map {|a| "https://t-m-f.ru#{a['href']}"}
    p vars_links.count
    p vars_links
  end

  def self.update_product(tov, data)
    if tov.check
      return if tov.p4.split(' ## ').include?(data[:p4])
      if tov.update(p4: "#{tov.p4} ## #{data[:p4]}")
        p "---- update товара только p4 #{tov.fid} -- p4: #{tov.p4} -- всего: #{Tmf.count}}"
      else
        p "!!!!ОШИБКА UPDATE!!!!! товара #{tov.fid} -- TIME: #{Time.now}"
      end
    else
      tov.update(check: true)
      tov.update(data)
      p "---->>> update товара #{tov.fid} -- p4: #{tov.p4} -- всего: #{Tmf.count}}"
    end
  end

  def self.create_product(data)
    pp tov = Tmf.new(data)
    if tov.save
      pp tov
      p "+++++ создан товар #{tov.fid} -- всего: #{Tmf.count}"
    else
      p "!!!!ОШИБКА!!!!! товара #{tov.fid}"
    end
  end

  def self.get_pict_main(doc)
    result = []
    doc_picts = doc.css('.wrapp_thumbs li')
    if doc_picts.present?
      result = doc_picts.map do |doc_pict|
        "https://t-m-f.ru#{doc_pict['data-big_img']}" if doc_pict['data-big_img'].present?
      end
    elsif doc.at('.item_main_info img')
      result << "https://t-m-f.ru#{doc.at('.item_main_info img')['src']}"
    else
      nil
    end
    result.join(' ')
  end

  def self.get_pict_vars(doc)
    result = []
    doc_picts = doc.css('.mod_content .left img')
    if doc_picts.present?
      result = doc_picts.map do |doc_pict|
        "https://t-m-f.ru#{doc_pict['src']}" if doc_pict['src'].present?
      end
    else
      nil
    end
    result.join(' ')
  end

  def self.get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  end

  def self.rest_client_get(url)
    response = RestClient.get(url)
    Nokogiri::HTML(response.body)
  end
end
