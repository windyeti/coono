class Services::CreateProductSaunaru
  def self.call
    Saunaru.all.each {|tov| tov.update(check: false, quantity: "0")}
    get_category(CategorySaunaru.first)
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

    product_urls = doc.css('.products .product_card .product_card-title a').map {|a| "https://saunaru.com#{a['href']}"}

    doc_pagination = doc.css('.pagination .pagination-item a')

    if doc_pagination.size > 0

      max_number = doc_pagination.map {|a| a['href'].split('=').last.to_i}.max

      (2..max_number).each do |number|
        pagianation_url = "#{category_url}?page=#{number}"
        doc_pagianation = get_doc(pagianation_url)
        product_urls += doc_pagianation.css('.products .product_card .product_card-title a').map {|a| "https://saunaru.com#{a['href']}"}
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

      tries = 0
      begin
        # у одного товара fid окзался в другом месте
        fid = doc.at('.product-data .product-form input[name="variant_id"]') ? doc.at('.product-data .product-form input[name="variant_id"]')['value'] : doc.at('.product-data select[name="variant_id"] option')['value']
        tov = Saunaru.find_by(fid: fid)
      rescue
        tries += 1
        retry if tries <= 2
        File.open("#{Rails.public_path}/try_get_fid.txt", "a+") do |file|
          file.write "attempt: #{tries} -- #{product_link} -- sku: #{sku}\n"
        end
      end

      p1 = doc.css('.product-properties dl').map do |doc_dl|
        name = doc_dl.at('dt').text.strip.gsub(/:/, "")
        value = doc_dl.at('dd').text.strip
        "#{name}: #{value}"
      end.reject(&:nil?).join(' --- ')

      quantity = get_quantity(doc)
      # quantity = doc.at(".product-label") && doc.at(".product-label").text == "Распродано" ? "Нет в наличии" : "В наличии"

      title = doc.at('.product-title').text.strip rescue nil

      desc1 = doc.at('.product-description').inner_html.gsub(/\s+/, " ") rescue ""
      desc2 = doc.at('[data-tab="description"]').inner_html.gsub(/\s+/, " ") rescue ""

      desc = desc1 + desc2

      sku = doc.at('span[itemprop="sku"]').text.strip rescue nil

      price = doc.at('.product-price').text.gsub(/\s|руб| /, '') rescue nil
      oldprice = doc.at('.product-old_price').text.gsub(/\s|руб| /, '') rescue nil

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
    p "Total: #{Saunaru.count}"
  end

  def self.update_product(tov, data)
    if tov.check
      return if tov.p4.split(' ## ').include?(data[:p4])
      if tov.update(p4: "#{tov.p4} ## #{data[:p4]}")
        p ">>>>>>>> update p4 товара #{tov.fid} -- p4: #{tov.p4} -- всего: #{Saunaru.count}}"
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
    tov = Saunaru.new(data)
    if tov.save
      pp tov
      p "+++++ создан товар #{tov.fid} -- всего: #{Saunaru.count}"
    else
      p "!!!!ОШИБКА!!!!! товара #{tov.fid}"
    end
  end

  def self.get_pict(doc)
    result = []
    doc_picts = doc.css('.product-gallery a')
    if doc_picts.present?
      result = doc_picts.map do |doc_pict|
        doc_pict['href']
      end
    else
      nil
    end
    result.join(' ')
  end

  def self.get_quantity(doc)
  # Nokogiri не может взять текст "В наличии", так он вставляется через js.
    doc.at(".product-label") && doc.at(".product-label").text == "Распродано" ? "0" : "100"
  end

  def self.get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  end
end
