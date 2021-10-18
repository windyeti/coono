class Services::CreateProductTeplodar
  def self.call
    Teplodar.all.each {|tov| tov.update(check: false, quantity: "0")}
    get_category(CategoryTeplodar.first)
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

    # есть две структуры для продуктов
    if doc.at('.card-page-component-product-detail')
      doc_components = doc.css('.component-product-item')
      get_component(doc_components, category_path_name, category_url)
    else
      product_urls = doc.css('.product-item .product-item-detail__name a').map {|a| "https://www.teplodar.ru#{a['href']}"}

      button = doc.at('.js-show-more')

      if button
        count_pages = button['data-page-cnt'].to_i
        catalog_query = button['data-uid']

        (2..count_pages).each do |count_page|
          url = "#{category_url}?AJAX_PAGER=1&PAGEN_1=#{count_page}&UID=#{catalog_query}"
          doc = get_doc(url)
          product_urls += doc.css('.product-item-detail__name a').map{|item| "https://www.teplodar.ru#{item['href']}"}
        end
      end

      get_product(product_urls, category_path_name)
    end
  end

  def self.get_component(doc_components, category_path_name, category_url)

    doc_components.each do |doc_component|
      doc_button = doc_component.at('.component-product-item-buttons .add-cart-button')
      p "START Компонент <<<< начали собирать данные по продукту #{doc_button['data-name']}"

      fid = doc_button['data-id']

      tov = Teplodar.find_by(fid: fid)

      title = doc_button['data-name']
      price = doc_button['data-price']
      desc = doc_component.at('.component-product-item-detail-list').inner_html.strip rescue nil

      p1 = ""

      link = category_url
      p4 = category_path_name

      quantity = doc.at('.label-outOfProduction') && doc.at('.label-outOfProduction').text.strip == 'Снято с производства' ? '0' : '100'

      categories = category_path_name.split('/')

      data = {
        fid: fid,
        title: title,
        price: price,
        desc: desc,
        quantity: quantity,
        p1: p1,
        p4: p4,
        link: link,
        cat: categories[1],
        cat1: categories[2],
        cat2: categories[3],
        cat3: categories[4],
        cat4: categories[5]
      }
      if tov.present?
        p '================ UPDATE ================'
        update_product(tov, data)
      else
        create_product(data)
      end
      p "END <<<< закончили собирать данные на продукт:: #{fid}"
    end
    p "Total: #{Teplodar.count}"
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

      button = doc.at('.add-cart-button')

      title = button.present? && button['data-name'].present? ? button['data-name'] : doc.at('.head-top-block h1').text.strip

      if button
        fid = button['data-id']
        tov = Teplodar.find_by(fid: fid)
      else
        fid = nil
        tov = Teplodar.find_by(title: title)
      end


      sku = nil
      p1 = doc.css('.model-specifications tr').map do |doc_tr|
        doc_tds = doc_tr.css('td')
        name = doc_tds[0].text.strip.gsub(/:/, "") rescue nil
        value = doc_tds[1].text.strip rescue nil
        if name.include? "Код товара"
          sku = value
          next
        end
        "#{name}: #{value}" unless name.nil? && value.nil?
      end.reject(&:nil?).join(' --- ')

      quantity = nil

      price = button && button['data-price'] ? button['data-price'] : doc.at('.card-page-product-price-block__price').text.strip.gsub(/\s|&nbsp;| |руб./, "")

      desc = doc.at('.page-card-description-section').inner_html.gsub(/\s+/, " ") rescue nil

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
    p "Total: #{Teplodar.count}"
  end

  def self.update_product(tov, data)
    if tov.check
      return if tov.p4.split(' ## ').include?(data[:p4])
      if tov.update(p4: "#{tov.p4} ## #{data[:p4]}")
        p ">>>>>>>> update p4 товара #{tov.fid} -- p4: #{tov.p4} -- всего: #{Teplodar.count}}"
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
    tov = Teplodar.new(data)
    if tov.save
      pp tov
      p "+++++ создан товар #{tov.fid} -- всего: #{Teplodar.count}"
    else
      p "!!!!ОШИБКА!!!!! товара #{tov.fid}"
    end
  end

  def self.get_pict(doc)
    result = []
    doc_picts = doc.css('.card-page-product-slider-thumbs .card-page-product-slider-thumbs-item-image img')
    if doc_picts.present?
      result = doc_picts.map do |doc_pict|
        h = doc_pict['data-src'].split("/")
        href = "/#{h[1]}/#{h[3]}/#{h[4]}/#{h[6]}"
        "https://www.teplodar.ru#{href}"
      end
    else
      ""
    end
    result.join(' ')
  end

  def self.get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  end
end
