class Services::CreateProductNkamin
  def self.call(category)
    # НЕТ КАТЕГОРИЙ !!!
    # TODO сделать по-умолчанию check: true
    Nkamin.all.each {|tov| tov.update(check: false, quantity: "0")}
    get_category(category)
  end

  def self.get_category(category)

    category[:children].each do |subordinate|
      get_category(subordinate)
    end

    get_product_links(category[:link], category[:category_path]) unless category[:category_path] == "Каталог"
  end

  def self.get_product_links(category_url, category_path_name)
    doc = get_doc(category_url)

    product_urls = doc.css('#catalog .item .name > a').map {|a| "https://nkamin.ru#{a['href']}"}

    page = 1

    loop do
      page += 1
      url = "#{category_url}?page=#{page}"
      doc_pagianation = get_doc(url)
      new_product_urls = doc_pagianation.css('#catalog .item .name > a').map {|a| "https://nkamin.ru#{a['href']}"}
      break unless new_product_urls.present?
      product_urls += new_product_urls
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

      fid = doc.at('.articool').text.gsub("Арт. ", "").strip
      # fid = doc.at('#btn-add-to-cart-product')['product-id']

      tov = Nkamin.find_by(fid: fid)

      p1 = doc.css('.TabBoxCont .card_tab_text')[1].css('tr').map do |doc_tr|
        tds = doc_tr.css('td')
        "#{tds[0].text.strip}: #{tds[1].text.strip}"
      end.join(' --- ')

      sku = doc.at('.articool').text.gsub("Арт. ", "").strip

      pict = get_pict(doc)

      quantity = doc.css('.card_data_info .green, .card_data_info .red').text.strip rescue nil

      title = doc.at('.page-title').text.strip rescue nil
      desc = doc.css('.TabBoxCont .card_tab_text')[0].inner_html rescue nil
      price = doc.at('.price_formatted').text.strip.gsub(" ", "") rescue nil
      oldprice = doc.at('.price_old em').text.strip.gsub(" ", "") rescue nil
      link = product_link
      p4 = category_path_name

      categories = category_path_name.split('/')
      mtitle = doc.at('title').text.strip rescue nil
      mdesc = doc.at('meta[name="description"]')['content'] rescue nil
      mkeyw = doc.at('meta[name="keywords"]')['content'] rescue nil

      data = {
        fid: fid,
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
    p "Total: #{Nkamin.count}"
  end

  def self.update_product(tov, data)
    if tov.check
      return if tov.p4.split(' ## ').include?(data[:p4])
      if tov.update(p4: "#{tov.p4} ## #{data[:p4]}")
        p "---- update товара только p4 #{tov.fid} -- p4: #{tov.p4} -- всего: #{Nkamin.count}}"
      else
        p "!!!!ОШИБКА UPDATE!!!!! товара #{tov.fid} -- TIME: #{Time.now}"
      end
    else
      tov.update(check: true)
      tov.update(data)
      p "---->>> update товара #{tov.fid} -- p4: #{tov.p4} -- всего: #{Nkamin.count}}"
    end
  end

  def self.create_product(data)
    pp tov = Nkamin.new(data)
    if tov.save
      pp tov
      p "+++++ создан товар #{tov.fid} -- всего: #{Nkamin.count}"
    else
      p "!!!!ОШИБКА!!!!! товара #{tov.fid}"
    end
  end

  def self.get_pict(doc)
    result = []
    doc_picts = doc.css('.slick-SliderCardNav img')
    if doc_picts.present?
      result = doc_picts.map do |doc_pict|
        "https://nkamin.ru#{doc_pict['src'].gsub("-100", "-600")}"
      end
    elsif doc.at('.SliderCard a')
      result << "https://nkamin.ru#{doc.at('.SliderCard a')['href']}"
    else
      nil
    end
    result.join(' ')
  end

  def self.get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  end
end
