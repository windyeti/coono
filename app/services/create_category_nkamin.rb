class Services::CreateCategoryNkamin
  def self.call

    # У этого поставщика не отслеживаются отсутствующие Категории,
    # так как Подкатегории диблируются в Категориях
    # БЕЗ СОЗДАНИЯ КАТЕГОРИЙ
    url = ""
    doc = get_doc("https://nkamin.ru/catalog")

    category_structure(doc, url, "Каталог", '', 0)

    # CategoryNkamin.all.each {|c| c.update(parsing: false)}
    # get_structure(doc, url, "Каталог", '', 0)
  end

  def self.category_structure(doc, url, name, category_path, level)

    selector = {
      "0"=> '#header .navigation > li',
      "1"=> '',
      "2"=> '',
      "3"=> '',
      "4"=> '',
    }

    # selector = {
    #   "0"=> '#header .navigation > li',
    #   "1"=> '.navigation_drop_box .list_nav > li',
    #   "2"=> '> ul li',
    #   "3"=> '',
    #   "4"=> '',
    # }

    category = {
      name: name,
      link: category_path == "" ? "https://nkamin.ru/catalog" : "https://nkamin.ru#{url}",
      category_path: category_path == "" ? "Каталог" : category_path,
      children: []
    }

    doc_subcategories = selector[level.to_s] != '' ? doc.css(selector[level.to_s]) : []

    doc_subcategories.each do |doc_subcategory|
      url_subcategory = doc_subcategory.at('a')['href']
      name_subcategory = doc_subcategory.at('a').text.strip.gsub("/","&#47;")
      category_path = "#{category[:category_path]}/#{name_subcategory}"

      category[:children] << category_structure(doc_subcategory, url_subcategory, name_subcategory, category_path, level + 1)
    end
    category
  end

  def self.delete_not_exits_subcategory(old_sub, new_sub)
    old_sub = old_sub.present? ? old_sub.map {|sub| sub.category_path} : []

    (old_sub - new_sub).each do |category_path|
      CategoryNkamin.find_by(category_path: category_path).destroy
    end
  end

  def self.get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 20, :method => :get, :verify_ssl => false))
  end
end
