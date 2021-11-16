class Services::CreateProductContact
  def self.call
    Contact.all.each {|tov| tov.update(check: false, quantity: "0")}
    get_category(CategoryContact.first)
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
    doc = rest_client_get(category_url)

    p "START <<<< начали собирать данные по продукту #{category_url}"
    data_products = get_data_products(doc)

    get_product(doc, data_products, category_url, category_path_name)
  end

  def self.get_product(doc, data_products, product_link, category_path_name)
    data_products.each do |data_product|
      next if data_product.empty?


      sku = data_product["Артикул"]
      fid = sku

      tov = Contact.find_by(fid: fid)
      title = data_product["Наименование"]

      quantity = data_product["Наличие"] == 'В наличии' ? '100' : '0'

      price = data_product["Цена"].gsub(/\s|₽| | | /, "").strip

      data_product.delete("Артикул")
      data_product.delete("Наименование")
      data_product.delete("Наличие")
      data_product.delete("Цена")

      p1 = data_product.map do |key, value|
        "#{key}: #{value}" if key.present? && value.present?
      end.reject(&:nil?).join(' --- ')

      desc = doc.at('#description').inner_html.gsub(/\s+/, " ") rescue nil

      pict = doc.css(".fancybox-media").map {|a| "https://contactplus.ru#{a['href']}"}.join(' ')

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
      p "END <<<< закончили собирать данные на продукт:: #{product_link}"
    end
    p "Total: #{Contact.count}"
  end

  def self.get_data_products(doc)
    result = []
    doc_table = doc.at('.item-table')
    return [] unless doc_table
    doc_table_headers = doc_table.css('.itable-header td')
    table_headers = {}
    doc_table_headers.each do |doc_table_header|
      table_headers[doc_table_header.attribute('class').value] = "#{doc_table_header.text.strip}"
    end
    doc_trs = doc_table.css('tr:not(.itable-header):not(.sub-row)')
    doc_trs.each do |doc_tr|
      product = {}
      table_headers.map do |key, name|
        value = doc_tr.at(".#{key}").text.strip rescue next
        product[name] = value
      end
      result << product
    end
    result
  end

  def self.update_product(tov, data)
    if tov.check
      return if tov.p4.split(' ## ').include?(data[:p4])
      if tov.update(p4: "#{tov.p4} ## #{data[:p4]}")
        p ">>>>>>>> update p4 товара #{tov.fid} -- p4: #{tov.p4} -- всего: #{Contact.count}}"
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
    tov = Contact.new(data)
    if tov.save
      pp tov
      p "+++++ создан товар #{tov.fid} -- всего: #{Contact.count}"
    else
      p "!!!!ОШИБКА!!!!! товара #{tov.fid}"
    end
  end

  def self.rest_client_get(url)
    response = RestClient.get(url)
    Nokogiri::HTML(response.body)
  end

  def self.get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  end
end
