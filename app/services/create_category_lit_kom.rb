class Services::CreateCategoryLitKom
  def self.call

    CategoryLitKom.all.each {|c| c.update(parsing: false)}

    url_source = "https://lit-kom.ru"
    selector_top_level = '#vmenu_61 .menu-level- > .ty-menu__submenu-item-header a'
    selector_other_level = '.ty-mainbox-body .subcategories a'

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
    # url = "#{Rails.application.credentials[:shop][:old_domain]}#{url}" unless url[/http|https/]
    # p url = URI.encode(url)

    doc = get_doc url

    selector = current_top_level ? selector_top_level : selector_other_level

    p category = CategoryLitKom.find_by(category_path: data_category_from_up[:category_path])
    unless category
      p category = CategoryLitKom.create!(
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
        name = doc_subcategory.text.strip.gsub("/","&#47;")
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
      CategoryLitKom.find_by(category_path: category_path).destroy
    end
  end

  def self.get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  end

end
