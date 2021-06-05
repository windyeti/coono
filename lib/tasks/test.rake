namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task t: :environment do
    doc = get_doc('https://gk-kovcheg.ru/catalog/nordflam/kaminnyie-topki/etna-right.html')

    # desc = doc.css('#content') rescue nil
    # if desc
    #   desc.at('.productCard').unlink
    #   desc = desc.inner_html
    # end
    # p desc
    #
    p get_pict(doc)

  end

  # def get_pict(doc)
  #   p '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
  #   result = []
  #   doc_picts = doc.css('.carousel a')
  #   if doc_picts.present?
  #     p '==============================++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
  #     result = doc_picts.map do |doc_pict|
  #       "https://gk-kovcheg.ru#{doc_pict['href']}"
  #     end
  #   elsif doc.at('#content .photo a')
  #     p '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
  #     result << "https://gk-kovcheg.ru#{doc.at('#content .photo a')['href']}"
  #   else
  #     p '---------------------------------------------------------------------------------------------'
  #     nil
  #   end
  #   result.join(' ')
  # end
  #
  # def get_doc(url)
  #   category_url = URI.escape(url)
  #   Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  # end

  # def get_pict(doc)
  #   result = []
  #   doc_picts = doc.css('.ty-product-thumbnails.ty-center.cm-image-gallery img')
  #   if doc_picts.present?
  #     result = doc_picts.map do |doc_pict|
  #       doc_pict['src'].gsub('/thumbnails/55/55', '').gsub('.png','')
  #     end
  #   elsif doc.at('.ty-product-bigpicture__img img')
  #     result << doc.at('.ty-product-bigpicture__img img')['src']
  #   end
  #   result.join(' ')
  # end

end
