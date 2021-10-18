class Services::CreateProductWellfit
  def self.call
    Wellfit.all.each {|tov| tov.update(check: false, quantity: "0")}
    get_category(CategoryWellfit.first)
  end

  def self.get_category(category)
    p "GUARD --> #{category.parsing}"
    p category.name
    return if category.parsing

    category.subordinates.each do |subordinate|
      subordinate.name
      get_category(subordinate)
    end

    get_product_links(category.link, category.category_path)
    # category.update(parsing: true)
  end

  def self.get_product_links(category_url, category_path_name)
    product_urls = []
    page = 0

    loop do
      page += 1
      pagianation_url = "#{category_url}?page=#{page}"
      doc_pagianation = get_doc(pagianation_url)
      pagination_product_urls = doc_pagianation.css('.product .title a').map {|a| a['href']}
      break if product_urls.last == pagination_product_urls.last || pagination_product_urls.count == 0
      product_urls += pagination_product_urls
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

      fid = doc.at('input[name="product_id"]')['value']
      tov = Wellfit.find_by(fid: fid)

      title = doc.at('h1').text.strip rescue nil
      p1 = doc.css(".white-section:not(.description-section) .li-vkl").map {|i| i.text.strip}.join(" --- ") rescue nil

      pict = get_pict(doc)

      quantity = doc.at('#product .availability').text.strip == 'В наличии' ? '100' : '0' rescue nil

      desc = doc.at('.description-section').inner_html rescue nil
      price = doc.at('.newPrice').text.strip.gsub(/р.|\s| /, "") rescue nil
      oldprice = nil
      link = product_link
      p4 = category_path_name

      categories = category_path_name.split('/')
      mtitle = doc.at('title').text.strip rescue nil
      mdesc = doc.at('meta[name="description"]')['content'] rescue nil
      mkeyw = doc.at('meta[name="keywords"]')['content'] rescue nil

      data = {
        fid: fid,
        sku: nil,
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
    p "Total: #{Wellfit.count}"
  end

  def self.update_product(tov, data)
    if tov.check
      return if tov.p4.split(' ## ').include?(data[:p4])
      if tov.update(p4: "#{tov.p4} ## #{data[:p4]}")
        p "---- update товара только p4 #{tov.fid} -- p4: #{tov.p4} -- всего: #{Wellfit.count}}"
      else
        p "!!!!ОШИБКА UPDATE!!!!! товара #{tov.fid} -- TIME: #{Time.now}"
      end
    else
      tov.update(check: true)
      tov.update(data)
      p ">>>>>> update товара #{tov.fid} -- p4: #{tov.p4} -- всего: #{Wellfit.count}}"
    end
  end

  def self.create_product(data)
    pp tov = Wellfit.new(data)
    if tov.save
      pp tov
      p "+++++ создан товар #{tov.fid} -- всего: #{Wellfit.count}"
    else
      p "!!!!ОШИБКА!!!!! товара #{tov.fid}"
    end
  end

  def self.get_pict(doc)
    result = []
    doc_picts = doc.css('#example1 a')
    if doc_picts.present?
      result = doc_picts.map do |doc_pict|
        doc_pict['href']
      end
    else
      nil
    end
    result.join(' ')
  end

  def self.get_doc(url)
    # category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => url, :timeout => 100, :method => :get, :verify_ssl => false))
  end
end
