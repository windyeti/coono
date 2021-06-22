namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task p: :environment do
    # link = 'https://t-m-f.ru/catalog-new/model/komplektuyushchie_dlya_pechey/chugunnye_kruzhki/#1931'
    # link = 'https://t-m-f.ru/catalog-new/mod/lyuvers_f76_dotsent_inox/'
    # link = 'https://t-m-f.ru/catalog-new/mod/lyuvers_f57_inzhener_inox/'
    link = 'https://t-m-f.ru/catalog-new'
    doc = rest_client_get link
    selector_top_level = '.catalog_section_list .section_info li.name a'
    doc_subcategories = doc.css(selector_top_level)

    doc_subcategories.each do |doc_subcategory|
      doc_subcategory.at(".grey").unlink
      p doc_subcategory.text.strip.gsub("/","&#47;").gsub(/ /, "")
    end

  end

  task t: :environment do

  end

  def get_pict_vars(doc)
    result = []
    doc_picts = doc.css('.mod_content .left img')
    if doc_picts.present?
      result = doc_picts.map do |doc_pict|
        "https://t-m-f.ru#{doc_pict['src']}" if doc_pict['src'].present?
      end
    else
      nil
    end
    result.join(' ')
  end

  def get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  end

  def rest_client_get(url)
    response = RestClient.get(url)
    Nokogiri::HTML(response.body)
  end

end
