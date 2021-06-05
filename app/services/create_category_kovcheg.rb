class Services::CreateCategoryKovcheg
  def self.call

    CategoryKovcheg.all.each {|c| c.update(parsing: false)}

    url_source = "https://gk-kovcheg.ru/catalog"
    # selector_top_level = '.sideMenu > ul > li'
    # selector_other_level = '.first.parent ul a'

    create_structure(
      {
        link: url_source,
        category_path: 'Каталог'
      }
    )
  end

  def self.create_structure(data_category_from_up)
    url = data_category_from_up[:link]
    # url = "https://gk-kovcheg.ru/#{url}" unless url[/http|https/]

    doc = get_doc url

    # если категория с таким путем существует, то ее не создаем
    category = CategoryKovcheg.find_by(category_path: data_category_from_up[:category_path])
    unless category
      category = CategoryKovcheg.create!(
                   name: data_category_from_up[:name].nil? ? "Каталог" : data_category_from_up[:name],
                   link: url,
                   category_path: data_category_from_up[:category_path]
                  )
     end

    doc_subcategories2 = doc.css('.catalogCategories .item')

    category_paths2 = doc_subcategories2.map {|doc_subcategory2| "#{category.name}/#{doc_subcategory2.at('>a')['href'].gsub(/\/$/, '').split('/').last.strip.gsub("/","&#47;")}"}
    delete_not_exits_subcategory(category.subordinates, category_paths2)

    doc_subcategories2.each do |doc_subcategory2|
      # если категория с таким путем существует, то ее не создаем
      name2 = doc_subcategory2.at('>a')['href'].gsub(/\/$/, '').split('/').last.strip.gsub("/","&#47;")
      data2 = {
        link: "https://gk-kovcheg.ru/#{doc_subcategory2.at('>a')['href']}",
        name: name2,
        category_path: "#{category.category_path}/#{name2}"
      }

      category2 = CategoryKovcheg.find_by(category_path: data2[:category_path])
      unless category2
        category2 = CategoryKovcheg.create!(data2)
      end
      category.subordinates << category2

      doc_subcategories3 = doc_subcategory2.css('> ul li')

      category_paths3 = doc_subcategories3.map {|doc_subcategory3| "#{category2.name}/#{doc_subcategory3.at('a').text.strip.gsub("/","&#47;")}"}
      delete_not_exits_subcategory(category2.subordinates, category_paths3)

      doc_subcategories3.each do |doc_subcategory3|
        name3 = doc_subcategory3.at('a').text.strip.gsub("/","&#47;")
        data3 = {
          link: "https://gk-kovcheg.ru/#{doc_subcategory3.at('a')['href']}",
          name: name3,
          category_path: "#{category2.category_path}/#{name3}"
        }
        category3 = CategoryKovcheg.find_by(category_path: data3[:category_path])
        unless category3
          category3 = CategoryKovcheg.create!(data3)
        end
        category2.subordinates << category3
      end
    end
  end


  def self.delete_not_exits_subcategory(old_sub, new_sub)
    old_sub = old_sub.present? ? old_sub.map {|sub| sub.category_path} : []

    (old_sub - new_sub).each do |category_path|
      category_path
      CategoryKovcheg.find_by(category_path: category_path).destroy
    end
  end

  def self.get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  end

end
