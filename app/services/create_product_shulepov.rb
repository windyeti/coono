class Services::CreateProductShulepov
  def self.call
    # TODO сделать по-умолчанию check: true
    Shulepov.all.each {|tov| tov.update(check: false, quantity: "0")}
    get_category(CategoryShulepov.first)
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
    doc = get_doc("#{category_url}?SHOWALL_1=1")
    # удаляем рекламный блок
    doc.css('.bxr-list').last.unlink

    product_urls = doc.css('.bxr-list .bxr-element-container .bxr-element-name a').map {|a| "https://shulepov.ru#{a['href']}"}

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

      fid = doc.at('.bxr-basket-item-id') ? doc.at('.bxr-basket-item-id')['value'] : doc.at('.bxr-subscribe-wrap > span')['data-item']

      tov = Shulepov.find_by(fid: fid)

      sku = nil

      p1 = doc.css('.bxr-detail-props tr').map do |doc_tr|
        tds = doc_tr.css('td')
        "#{tds[0].text.strip}: #{tds[1].text.strip}"
      end.join(' --- ')

      pict = get_pict(doc)

      quantity = doc.css('.bxr-instock-wrap').text.strip rescue nil

      title = doc.at('h1[itemprop="name"]').text.strip rescue nil
      desc = doc.css('#bxr-detail-block-wrap').inner_html rescue nil
      price = doc.at('.bxr-market-current-price').text.strip.gsub(/руб|\s/, "") rescue nil
      oldprice = nil
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
    p "Total: #{Shulepov.count}"
  end

  def self.update_product(tov, data)
    if tov.check
      return if tov.p4.split(' ## ').include?(data[:p4])
      if tov.update(p4: "#{tov.p4} ## #{data[:p4]}")
        p "---- update товара только p4 #{tov.fid} -- p4: #{tov.p4} -- всего: #{Shulepov.count}}"
      else
        p "!!!!ОШИБКА UPDATE!!!!! товара #{tov.fid} -- TIME: #{Time.now}"
      end
    else
      tov.update(check: true)
      tov.update(data)
      p ">>>>>> update товара #{tov.fid} -- p4: #{tov.p4} -- всего: #{Shulepov.count}}"
    end
  end

  def self.create_product(data)
    pp tov = Shulepov.new(data)
    if tov.save
      pp tov
      p "+++++ создан товар #{tov.fid} -- всего: #{Shulepov.count}"
    else
      p "!!!!ОШИБКА!!!!! товара #{tov.fid}"
    end
  end

  def self.get_pict(doc)
    result = []
    doc_picts = doc.css('.ax-element-slider-main a')
    if doc_picts.present?
      result = doc_picts.map do |doc_pict|
        "https://shulepov.ru#{doc_pict['href']}"
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
end
