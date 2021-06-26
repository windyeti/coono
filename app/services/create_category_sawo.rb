class Services::CreateCategorySawo
  def self.call
    CategorySawo.all.each {|c| c.update(parsing: false)}

    url = ""
    doc = get_doc("https://sawo.ru/collection/all")

    category_structure(doc, url, "Каталог", "Каталог", 0)
  end

  def self.category_structure(doc, url, name, category_path, level)

    selector = {
      "0"=> '.sidebar .menu--collection .menu-node--collection_lvl_1',
      "1"=> '.menu-node--collection_lvl_2',
      "2"=> '.menu-node--collection_lvl_3',
      "3"=> '',
      "4"=> '',
    }

    p category = CategorySawo.find_by(category_path: category_path)
    unless category
      p category = CategorySawo.create(
        {
          name: name,
          link: category_path == "Каталог" ? "https://sawo.ru/collection/all" : url,
          category_path: category_path
        }
      )
    end

    doc_subcategories = selector[level.to_s] != '' ? doc.css(selector[level.to_s]) : []

    sub_category_paths = doc_subcategories.present? ? doc_subcategories.map {|doc_sub| "#{category.category_path}/#{doc_sub.at('a').text.strip.gsub("/","&#47;")}" } : []

    delete_not_exits_subcategory(category.subordinates, sub_category_paths)

    doc_subcategories.each do |doc_subcategory|
      url_subcategory = "https://sawo.ru#{doc_subcategory.at('a')['href']}"
      name_subcategory = doc_subcategory.at('a').text.strip.gsub("/","&#47;")
      category_path = "#{category.category_path}/#{name_subcategory}"

      category.subordinates << category_structure(doc_subcategory, url_subcategory, name_subcategory, category_path, level + 1)
    end
    category
  end


  def self.delete_not_exits_subcategory(old_sub, new_sub)
    old_sub = old_sub.present? ? old_sub.map {|sub| sub.category_path} : []

    (old_sub - new_sub).each do |category_path|
      CategorySawo.find_by(category_path: category_path).destroy
    end
  end

  def self.get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 20, :method => :get, :verify_ssl => false))
  end
end
