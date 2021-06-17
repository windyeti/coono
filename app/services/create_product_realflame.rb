class Services::CreateProductRealflame
  def self.call
    # TODO сделать по-умолчанию check: true
    Realflame.all.each {|tov| tov.update(check: false, quantity: "0")}
    get_category(CategoryRealflame.first)
  end

  def self.get_category(category)
    p "GUARD --> #{category.parsing}"
    p category.name
    p category.subordinates.count
    return if category.parsing

    category.subordinates.each do |subordinate|
      get_category(subordinate)
    end

    get_product_links(category.link, category.category_path)
    category.update(parsing: true)
  end

  def self.get_product_links(category_url, category_path_name)
    doc = get_doc(category_url)

    product_urls = doc.css('.product_list .product_image').map {|a| a['href']}

    doc_pagination = doc.css('.navigation a')

    if doc_pagination.size > 0

      max_number = doc_pagination.map {|a| a['href'].split('=').last.to_i}.max

      (2..max_number).each do |number|
        pagianation_url = "#{category_url}?page=#{number}"
        doc_pagianation = get_doc(pagianation_url)
        product_urls += doc_pagianation.css('.product_list .product_image').map {|a| a['href']}
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
      title = doc.at('h1.big-title > b').text.strip rescue nil
      fid = title
      tov = Realflame.find_by(fid: fid)


      p1 = doc.css('.description-list .row').map do |doc_item|
        name = doc_item.at('.title').text.strip.gsub(/\s+/, " ") rescue nil
        value = doc_item.at('.text').text.strip rescue nil
        "#{name}: #{value}"
      end.reject(&:nil?).join(' --- ')

      quantity = doc.at('#quickorder').text.strip rescue nil

      title = title
      desc = doc.at('#short_description_content').inner_html.gsub(/\s+/, " ") rescue nil
      sku = nil
      price = doc.at('.new-price').text.strip.gsub(/\s|₽| /, "") rescue nil

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
        oldprice: nil,
        pict: get_pict(doc),
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
      p "END <<<< закончили собирать данные на продукт:: #{product_link}"
    end
    p "Total: #{Realflame.count}"
  end

  def self.update_product(tov, data)
    if tov.check
      return if tov.p4.split(' ## ').include?(data[:p4])
      if tov.update(p4: "#{tov.p4} ## #{data[:p4]}")
        p ">>>>>>>> update p4 товара #{tov.fid} -- p4: #{tov.p4} -- всего: #{Realflame.count}}"
      else
        p "!!!!ОШИБКА UPDATE!!!!! товара #{tov.fid} -- TIME: #{Time.now}"
      end
    else
      tov.update(check: true)
      tov.update(data)
      p "---- update товара #{tov.fid} -- p4: #{tov.p4}"
    end
  end

  def self.create_product(data)
    tov = Realflame.new(data)
    if tov.save
      pp tov
      p "+++++ создан товар #{tov.fid} -- всего: #{Realflame.count}"
    else
      p "!!!!ОШИБКА!!!!! товара #{tov.fid}"
    end
  end

  def self.get_pict(doc)
    result = []
    doc_picts = doc.css('#thumbs_list_frame a')
    if doc_picts.present?
      result = doc_picts.map do |doc_pict|
        doc_pict['href']
      end
    elsif doc.at('#bigpic')
      result << doc.at('#bigpic')['src']
    end
    result.join(' ')
  end

  def self.get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  end
end
