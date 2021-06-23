class Services::CreateCategoryDim
  def self.call
    CategoryDim.all.each {|c| c.update(parsing: false)}

    url = ""
    doc = get_doc("https://dimplex.ru/map")

    category_structure(doc, url, "Каталог", "Каталог", 0)
  end

  def self.category_structure(doc, url, name, category_path, level)
p url
    selector = {
      "0"=> '.content.black-link > ul > li:nth-child(1) > ul > li',
      "1"=> '> ul > li',
      "2"=> '> ul > li',
      "3"=> '> ul > li',
      "4"=> '> ul > li',
      "5"=> '> ul > li',
      "6"=> '> ul > li',
    }

    p category = CategoryDim.find_by(category_path: category_path)
    unless category
      p category = CategoryDim.create(
        {
          name: name,
          link: category_path == "Каталог" ? "https://dimplex.ru/catalog" : url,
          category_path: category_path
        }
      )
    end

    doc_subcategories = selector[level.to_s] != '' ? doc.css(selector[level.to_s]) : []

    sub_category_paths = doc_subcategories.present? ? doc_subcategories.map {|doc_sub| "#{category.category_path}/#{doc_sub.at('a').text.strip.gsub("/","&#47;")}" } : []

    delete_not_exits_subcategory(category.subordinates, sub_category_paths)

    if doc_subcategories.size > 0
      doc_subcategories.each do |doc_subcategory|
        # прерываем создание категорий без Ссылки, это уже не наши товары
        return unless doc_subcategory.at('> a')
        url_subcategory = "https://dimplex.ru#{doc_subcategory.at('> a')['href']}"
        name_subcategory = doc_subcategory.at('> a').text.strip.gsub("/","&#47;")
        category_path = "#{category.category_path}/#{name_subcategory}"

        category.subordinates << category_structure(doc_subcategory, url_subcategory, name_subcategory, category_path, level + 1)
      end
    end
    category
  end
  # def self.call
  #   CategoryDim.all.each {|c| c.update(parsing: false)}
  #
  #   url = ""
  #   doc = get_doc("https://dimplex.ru/catalog")
  #
  #   category_structure(doc, url, "Каталог", "Каталог", 0)
  # end
  #
  # def self.category_structure(doc, url, name, category_path, level)
  #
  #   selector = {
  #     "0"=> '.box.mrg:nth-child(3n)',
  #     "1"=> 'ul li',
  #     "2"=> '',
  #     "3"=> '',
  #     "4"=> '',
  #   }
  #
  #   p category = CategoryDim.find_by(category_path: category_path)
  #   unless category
  #     p category = CategoryDim.create(
  #       {
  #         name: name,
  #         link: category_path == "Каталог" ? "https://dimplex.ru/catalog" : url,
  #         category_path: category_path
  #       }
  #     )
  #   end
  #
  #   doc_subcategories = selector[level.to_s] != '' ? doc.css(selector[level.to_s]) : []
  #
  #   p sub_category_paths = doc_subcategories.present? ? doc_subcategories.map {|doc_sub| "#{category.category_path}/#{doc_sub.at('a').text.strip.gsub("/","&#47;")}" } : []
  #
  #   delete_not_exits_subcategory(category.subordinates, sub_category_paths)
  #
  #   doc_subcategories.each do |doc_subcategory|
  #     url_subcategory = doc_subcategory.at('a')['href']
  #     name_subcategory = doc_subcategory.at('a').text.strip.gsub("/","&#47;")
  #     category_path = "#{category.category_path}/#{name_subcategory}"
  #
  #     category.subordinates << category_structure(doc_subcategory, url_subcategory, name_subcategory, category_path, level + 1)
  #   end
  #   category
  # end


  def self.delete_not_exits_subcategory(old_sub, new_sub)
    old_sub = old_sub.present? ? old_sub.map {|sub| sub.category_path} : []

    (old_sub - new_sub).each do |category_path|
      CategoryDim.find_by(category_path: category_path).destroy
    end
  end

  def self.get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 20, :method => :get, :verify_ssl => false))
  end
end
