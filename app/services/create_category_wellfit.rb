class Services::CreateCategoryWellfit
  def self.call
    CategoryWellfit.all.each {|c| c.update(parsing: false)}

    url = ""
    doc = get_doc("https://www.wellfitness.ru")

    category_structure(doc, url, "Каталог", "Каталог", 0)
  end

  def self.category_structure(doc, url, name, category_path, level)

    selector = {
      "0"=> '#nav .hvks > ul > li',
      "1"=> '.pdd-menu-contener > ul > li',
      "2"=> '',
      "3"=> '',
      "4"=> '',
    }

    p category = CategoryWellfit.find_by(category_path: category_path)
    unless category
      p category = CategoryWellfit.create(
        {
          name: name,
          link: category_path == "Каталог" ? "https://www.wellfitness.ru" : url,
          category_path: category_path
        }
      )
    end

    doc_subcategories = selector[level.to_s] != '' ? doc.css(selector[level.to_s]) : []

    sub_category_paths = doc_subcategories.present? ? doc_subcategories.map {|doc_sub| "#{category.category_path}/#{doc_sub.at('a').text.strip.gsub("/","&#47;")}" } : []

    delete_not_exits_subcategory(category.subordinates, sub_category_paths)

    doc_subcategories.each do |doc_subcategory|
      url_subcategory = doc_subcategory.at('> a')['href']
      name_subcategory = doc_subcategory.at('> a').text.strip.gsub("/","&#47;")
      category_path = "#{category.category_path}/#{name_subcategory}"

      category.subordinates << category_structure(doc_subcategory, url_subcategory, name_subcategory, category_path, level + 1)
    end
    category
  end


  def self.delete_not_exits_subcategory(old_sub, new_sub)
    old_sub = old_sub.present? ? old_sub.map {|sub| sub.category_path} : []

    (old_sub - new_sub).each do |category_path|
      CategoryWellfit.find_by(category_path: category_path).destroy
    end
  end

  def self.get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 20, :method => :get, :verify_ssl => false))
  end
end
