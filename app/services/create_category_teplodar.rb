class Services::CreateCategoryTeplodar
  def self.call

    CategoryTeplodar.all.each {|c| c.update(parsing: false)}

    url_source = "https://www.teplodar.ru/catalog"
    selector_top_level = '.category-main-page-item .category-main-page-item__title a'
    selector_other_level = '.product-list-view-item-detail__name.section-title-medium a'

    create_structure(
      {
        link: url_source,
        category_path: 'Каталог'
      },
      selector_top_level,
      selector_other_level,
      true
    )
  end

  def self.create_structure(data_category_from_up, selector_top_level, selector_other_level, current_top_level = false)
    url = data_category_from_up[:link]
    url = "https://www.teplodar.ru#{url}" unless url[/http|https/]
    # p url = URI.encode(url)

    doc = get_doc url

    selector = current_top_level ? selector_top_level : selector_other_level

    p category = CategoryTeplodar.find_by(category_path: data_category_from_up[:category_path])
    unless category
      p category = CategoryTeplodar.create!(
        name: data_category_from_up[:name].nil? ? "Каталог" : data_category_from_up[:name],
        link: url,
        category_path: data_category_from_up[:category_path]
      )
    end

    doc_subcategories = doc.css(selector)

    p subcategories = create_layer_sub(doc_subcategories, current_top_level, data_category_from_up[:category_path]) if doc_subcategories.present?

    # удаляем категории, которые были, но сейчас их нет
    delete_not_exits_subcategory(category.subordinates, subcategories)

    if subcategories.present?
      subcategories.each do |subcategory_data|
        category.subordinates << create_structure(subcategory_data, selector_top_level, selector_other_level)
      end
    end
    category
  end

  def self.create_layer_sub(doc_subcategories, current_top_level, category_path)
    result = []
    doc_subcategories.each do |doc_subcategory|

      if current_top_level
        link = doc_subcategory['href']
        name = doc_subcategory.text.strip.gsub("/","&#47;")
      else
        link = doc_subcategory['href']
        name = doc_subcategory.css("> text()").text.strip.gsub("/","&#47;")
      end

      result << {
        link: link,
        name: name,
        category_path: "#{category_path}/#{name}"
      }
    end
    result
  end

  def self.delete_not_exits_subcategory(old_sub, new_sub)
    old_sub = old_sub.present? ? old_sub.map {|sub| sub.category_path} : []
    new_sub = new_sub.present? ? new_sub.map {|sub| sub[:category_path]} : []

    (old_sub - new_sub).each do |category_path|
      CategoryTeplodar.find_by(category_path: category_path).destroy
    end
  end

  # это фильтры, а не категории
  # def self.call
  #   CategoryTeplodar.all.each {|c| c.update(parsing: false)}
  # 
  #   url = ""
  #   doc = get_doc("https://www.teplodar.ru/catalog")
  # 
  #   category_structure(doc, url, "Каталог", "Каталог", 0)
  # end
  # 
  # def self.category_structure(doc, url, name, category_path, level)
  # 
  #   selector = {
  #     "0"=> '.category-main-page-item',
  #     "1"=> '.category-main-page-item-list li',
  #     "2"=> '',
  #     "3"=> '',
  #     "4"=> '',
  #   }
  # 
  #   p category = CategoryTeplodar.find_by(category_path: category_path)
  #   unless category
  #     p category = CategoryTeplodar.create(
  #       {
  #         name: name,
  #         link: category_path == "Каталог" ? "https://www.teplodar.ru/catalog" : url,
  #         category_path: category_path
  #       }
  #     )
  #   end
  # 
  #   doc_subcategories = selector[level.to_s] != '' ? doc.css(selector[level.to_s]) : []
  # 
  #   if level == 0
  #     sub_category_paths = doc_subcategories.present? ? doc_subcategories.map {|doc_sub| "#{category.category_path}/#{doc_sub.at('.category-main-page-item__title a').text.strip.gsub("/","&#47;")}" } : []
  #   else
  #     sub_category_paths = doc_subcategories.present? ? doc_subcategories.map {|doc_sub| "#{category.category_path}/#{doc_sub.at('a').text.strip.gsub("/","&#47;")}" } : []
  #   end
  # 
  #   delete_not_exits_subcategory(category.subordinates, sub_category_paths)
  # 
  #   doc_subcategories.each do |doc_subcategory|
  #     if level == 0
  #       url_subcategory = doc_subcategory.at('.category-main-page-item__title a')['href']
  #       name_subcategory = doc_subcategory.at('.category-main-page-item__title a').text.strip.gsub("/","&#47;")
  #       category_path = "#{category.category_path}/#{name_subcategory}"
  #     else
  #       url_subcategory = doc_subcategory.at('a')['href']
  #       name_subcategory = doc_subcategory.at('a').text.strip.gsub("/","&#47;")
  #       category_path = "#{category.category_path}/#{name_subcategory}"
  #     end
  # 
  #     category.subordinates << category_structure(doc_subcategory, url_subcategory, name_subcategory, category_path, level + 1)
  #   end
  #   category
  # end
  # 
  # def self.delete_not_exits_subcategory(old_sub, new_sub)
  #   old_sub = old_sub.present? ? old_sub.map {|sub| sub.category_path} : []
  # 
  #   (old_sub - new_sub).each do |category_path|
  #     CategoryTeplodar.find_by(category_path: category_path).destroy
  #   end
  # end

  def self.get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 20, :method => :get, :verify_ssl => false))
  end
end
