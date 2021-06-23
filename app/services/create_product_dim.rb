class Services::CreateProductDim
  def self.call
    Dim.all.each {|tov| tov.update(check: false, quantity: "0")}
    get_category(CategoryDim.first)
  end

  def self.get_category(category)
    p "GUARD --> #{category.parsing}"
    p category.name
    return if category.parsing

    category.subordinates.each do |subordinate|
      get_category(subordinate)
    end

    get_product(category.link, category.category_path)
    category.update(parsing: true)
  end

  def self.get_product(product_link, category_path_name)
      p "START <<<< начали собирать данные по продукту #{product_link}"
      begin
        doc = get_doc(product_link)
      rescue
        p "Нет такой страницы #{product_link}"
        return
      end

      return if doc.at('.price').nil? || doc.at('.hdr-block.def h1').text.strip.include?("Каминокомплект")

      title = doc.at('.hdr-block.def h1').text.strip

      fid = title

      tov = Dim.find_by(fid: fid)

      sku = nil

      p1 = if doc.at('#paramList')
                doc_text_block = doc.at('#paramList')
                result = []
                doc_dts = doc_text_block.css('dt')
                doc_dds = doc_text_block.css('dd')
                doc_dts.each_with_index { |doc_dt, index| result << "#{doc_dt.text.strip}: #{doc_dds[index].text.strip}"}
                result.join(' --- ')
              else
                nil
              end

      pict = get_pict(doc)

      quantity = nil

      desc = doc.at('#fld-desc').inner_html.strip rescue nil
      price = doc.at('meta[itemprop="price"]')['content'] rescue nil
      oldprice = nil
      link = product_link

      categories_without_product = category_path_name.split('/')
      categories_without_product.pop
      categories = categories_without_product
      p4 = categories_without_product.join('/')

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
    p "Total: #{Dim.count}"
  end

  def self.update_product(tov, data)
    if tov.check
      return if tov.p4.split(' ## ').include?(data[:p4])
      if tov.update(p4: "#{tov.p4} ## #{data[:p4]}")
        p "---- update товара только p4 #{tov.fid} -- p4: #{tov.p4} -- всего: #{Dim.count}}"
      else
        p "!!!!ОШИБКА UPDATE!!!!! товара #{tov.fid} -- TIME: #{Time.now}"
      end
    else
      tov.update(check: true)
      tov.update(data)
      p ">>>>>> update товара #{tov.fid} -- p4: #{tov.p4} -- всего: #{Dim.count}}"
    end
  end

  def self.create_product(data)
    pp tov = Dim.new(data)
    if tov.save
      pp tov
      p "+++++ создан товар #{tov.fid} -- всего: #{Dim.count}"
    else
      p "!!!!ОШИБКА!!!!! товара #{tov.fid}"
    end
  end

  def self.get_pict(doc)
    result = []
    doc_picts = doc.css('.prod-thumb a')
    if doc_picts.present?
      result = doc_picts.map do |doc_pict|
        url = doc_pict['href']
        url[/http|https/] ? url : "https://dimplex.ru#{url}"
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
