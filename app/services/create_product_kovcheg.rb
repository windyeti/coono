class Services::CreateProductKovcheg
  def self.call
    # TODO сделать по-умолчанию check: true
    Kovcheg.all.each {|tov| tov.update(check: false, quantity: "0")}
    get_category(CategoryKovcheg.first)
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

    product_urls = doc.css('.catalogProducts .productImg a').map {|a| "https://gk-kovcheg.ru/#{a['href']}"}

    doc_pagination = doc.at('ul.pagination')
    number = doc.css('ul.pagination li a').last['href'].split('=').last.to_i if doc_pagination

    if doc_pagination
      page = 1
      (2..number).each do
        page += 1
        pagianation_url = "#{category_url}?page=#{page}"
        doc_pagianation = get_doc(pagianation_url)
        product_urls += doc_pagianation.css('.catalogProducts .productImg a').map {|a| "https://gk-kovcheg.ru/#{a['href']}"}
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

      fid = doc.at('form.ms2_form input[name="id"]')['value'] rescue nil

      tov = Kovcheg.find_by(fid: fid)

      p1 = doc.css('.productDescription .features tr').map do |doc_item|
        tds = doc_item.css('td')
        name = tds[0].text.strip.gsub(/:/,"")
        value = tds[1].text.strip
        "#{name}: #{value}" unless name == 'Артикул'
      end.reject(&:nil?).join(' --- ')

      sku = doc.css('.productDescription .features tr').map do |doc_item|
        tds = doc_item.css('td')
        name = tds[0].text.strip.gsub(/:/,"")
        value = tds[1].text.strip
        name == 'Артикул' ? value : nil
      end.reject(&:nil?).join(' --- ')

      pict = get_pict(doc)

      quantity = nil

      title = doc.at('.productDescription h1').text.strip rescue nil

      price = doc.at('.price').text.strip.gsub(" ", "") rescue nil

      link = product_link
      p4 = category_path_name

      categories = category_path_name.split('/')
      mtitle = doc.at('title').text.strip rescue nil
      mdesc = doc.at('meta[name="description"]')['content'] rescue nil
      mkeyw = doc.at('meta[name="keywords"]')['content'] rescue nil


      # ЗДЕСЬ ---- УДАЛЯЕТСЯ ЦЕЛЫЙ БЛОК& Ставим его здесь, когда уже все данные собраны
      desc = doc.css('#content') rescue nil
      if desc
        desc.at('.productCard').unlink
        desc = desc.inner_html.gsub(/<!--Карточка товара-->|<!--Видео-->|<!--Статья-->/,'').strip
      end

      data = {
        fid: fid,
        sku: sku,
        title: title,
        sdesc: nil,
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
    p "Total: #{Kovcheg.count}"
  end

  def self.update_product(tov, data)
    if tov.check
      return if tov.p4.split(' ## ').include?(data[:p4])
      if tov.update(p4: "#{tov.p4} ## #{data[:p4]}")
        p "---- update товара только p4 #{tov.fid} -- p4: #{tov.p4} -- всего: #{Kovcheg.count}}"
      else
        p "!!!!ОШИБКА UPDATE!!!!! товара #{tov.fid} -- TIME: #{Time.now}"
      end
    else
      tov.update(check: true)
      tov.update(data)
      p "---->>> update товара #{tov.fid} -- p4: #{tov.p4} -- всего: #{Kovcheg.count}}"
    end
  end

  def self.create_product(data)
    pp tov = Kovcheg.new(data)
    if tov.save
      pp tov
      p "+++++ создан товар #{tov.fid} -- всего: #{Kovcheg.count}"
    else
      p "!!!!ОШИБКА!!!!! товара #{tov.fid}"
    end
  end

  def self.get_pict(doc)
    result = []
    doc_picts = doc.css('.carousel a')
    if doc_picts.present?
      result = doc_picts.map do |doc_pict|
        "https://gk-kovcheg.ru#{doc_pict['href']}"
      end
    elsif doc.at('#content .photo a')
      result << "https://gk-kovcheg.ru#{doc.at('#content .photo a')['href']}"
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
