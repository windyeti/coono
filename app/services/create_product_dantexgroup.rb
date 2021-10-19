class Services::CreateProductDantexgroup
  def self.call
    Dantexgroup.all.each {|tov| tov.update(check: false, quantity: "0")}
    get_category(CategoryDantexgroup.first)
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

    product_type_1 = get_product_type_1(category_url)
    product_type_2 = get_product_type_2(category_url)


    product_urls = if product_type_1.present?
                       product_type_1
                     elsif product_type_2.present?
                       product_type_2
                     else
                       []
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

      title = doc.at('h1').text.strip
      fid = title

      tov = Dantexgroup.find_by(fid: fid)

      desc = if doc.at('.item-description')
                 doc.at('.item-description').inner_html.strip
               elsif doc.at('.grid.col2 .box.content')
                 doc.at('.grid.col2 .box.content').inner_html.strip
               else
                 nil
               end

      p1 = if doc.css('.item-info.box dl').present?
               get_p1_type_1(doc.css('.item-info.box dl'))
             elsif doc.css('.box.prod.mrg dl').present?
               get_p1_type_2(doc.css('.box.prod.mrg dl'))
             else
               nil
             end

      pict = get_images(doc)

      price = get_price(doc)

      link = product_link
      p4 = category_path_name

      quantity = "100"

      categories = category_path_name.split('/')
      mtitle = doc.at('title').text.strip rescue nil
      mdesc = doc.at('meta[name="description"]')['content'] rescue nil
      mkeyw = doc.at('meta[name="keywords"]')['content'] rescue nil

      pp data = {
        fid: fid,
        sku: nil,
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
    p "Total: #{Dantexgroup.count}"
  end

  def self.update_product(tov, data)
    if tov.check
      return if tov.p4.split(' ## ').include?(data[:p4])
      if tov.update(p4: "#{tov.p4} ## #{data[:p4]}")
        p "---- update товара только p4 #{tov.fid} -- p4: #{tov.p4} -- всего: #{Dantexgroup.count}}"
      else
        p "!!!!ОШИБКА UPDATE!!!!! товара #{tov.fid} -- TIME: #{Time.now}"
      end
    else
      tov.update(check: true)
      tov.update(data)
      p "---->>> update товара #{tov.fid} -- p4: #{tov.p4} -- всего: #{Dantexgroup.count}}"
    end
  end

  def self.create_product(data)
    pp tov = Dantexgroup.new(data)
    if tov.save
      pp tov
      p "+++++ создан товар #{tov.fid} -- всего: #{Dantexgroup.count}"
    else
      p "!!!!ОШИБКА!!!!! товара #{tov.fid}"
    end
  end

  def self.get_images(doc)
    doc_images = doc.css('.prod-thumb a')
    if doc_images.present?
      doc_images.map  do |a|
        "https://dantexgroup.ru#{a['data-image']}" unless a.attribute('class').value[/video|d3/]
      end.reject(&:nil?).join(' ')
    end
  end

  def self.get_p1_type_1(doc_p1)
    doc_p1.map do |doc_item|
      name = doc_item.at('dt').text.strip.gsub(/:/,"")
      value = doc_item.at('dd').text.strip
      "#{name}: #{value}"
    end.reject(&:nil?).join(' --- ')
  end

  def self.get_p1_type_2(doc_p1)
    result = []
    dds = doc_p1.css('dd')
    dts = doc_p1.css('dt')

    dds.each_with_index do |dd, index|
      result << "#{dts[index].text.strip.gsub(/:/,"")}: #{dd.text.strip}"
    end
    result.join(' --- ')
  end

  def self.get_product_type_1(category_url)
    doc = get_doc(category_url)
    doc.css('.catalog-layout.box li h3 > a').map {|a| "https://dantexgroup.ru#{a['href']}"}
  end

  def self.get_product_type_2(category_url)
    if get_doc(category_url).css('.wrapper script').present? && get_doc(category_url).css('.wrapper script').last.text.match(/\/\/\svar\slistData\s=\s'\?sflt=1&sectID=\d+';$/)
      sectID = get_doc(category_url).css('.wrapper script').last.text.match(/\/\/\svar\slistData\s=\s'\?sflt=1&sectID=\d+';$/).to_s.split('=').last.gsub("';","")
      doc = rest_client_get "https://dantexgroup.ru/catalog-kamin/get_content.php?3&?sflt=1&sectID=#{sectID}&&SHOWALL_1=1"
      doc.css('li a').map {|a| "https://dantexgroup.ru#{a['href']}"}
    end
  end

  def self.get_price(doc)
    price = doc.at('.box .price > span').text.strip.gsub(/\s| | /, "").to_i rescue nil
    if doc.at('h1').text.strip[/^Каминокомплект/]
      curComboID = doc.css('.wrapper script')[1]
                     .text
                     .match(/var\scurComboID\s=\s\d+;/).to_s.split('=').last.gsub(/'|;|\s/,"")
      combo_price = doc.at("#prod-list li[data-rel='#{curComboID}'] .price-block > .price")['data-price'].to_i
      curOfferID = doc.css('.wrapper script')[1]
                     .text
                     .match(/var\scurOfferID\s=\s\d+;/).to_s.split('=').last.gsub(/'|;|\s/,"")
      price = doc.at("#offer-list div.offer[data-id='#{curOfferID}']")['data-price'].to_i
      price = price + combo_price
    elsif doc.at('h1').text.strip[/^Портал/]
      curOfferID = doc.css('.wrapper script')[1]
                     .text
                     .match(/var\scurOfferID\s=\s\d+;/).to_s.split('=').last.gsub(/'|;|\s/,"")
      price = doc.at("#offer-list div.offer[data-id='#{curOfferID}']")['data-price'].to_i
    end
    price
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
