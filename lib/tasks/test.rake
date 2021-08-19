namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task p: :environment do
  end

  task t: :environment do
      # link = "https://www.wellfitness.ru/index.php?route=product/product&path=103_104&product_id=843"
      link = "https://www.wellfitness.ru/index.php?route=product/product&path=62&product_id=308"
      doc = get_doc(link)
      p doc.at('input[name="product_id"]')['value']
  end

  task p: :environment do
    # doc = get_doc "https://dantexgroup.ru/catalog-kamin/get_content.php?3&?sflt=1&sectID=1281"
    link = "https://dantexgroup.ru/catalog/kaminy/elektrokaminy/portaly/dimplex/"
    sectID = get_doc(link).css('.wrapper script').last.text.match(/\/\/\svar\slistData\s=\s'\?sflt=1&sectID=\d+';$/).to_s.split('=').last.gsub("';","")
    doc = rest_client_get "https://dantexgroup.ru/catalog-kamin/get_content.php?3&?sflt=1&sectID=#{sectID}&&SHOWALL_1=1"
    p doc.css('li a').map {|a| a['href']}
  end

  # def get_pict(doc)
  #   result = []
  #   doc_picts = doc.css('#example1 a')
  #   if doc_picts.present?
  #     result = doc_picts.map do |doc_pict|
  #       doc_pict['href']
  #     end
  #   else
  #     nil
  #   end
  #   result.join(' ')
  # end

  def get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  end
end
