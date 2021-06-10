namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task p: :environment do
    product_link = 'https://nkamin.ru/catalog/tovary-dlya-montazha/termoizolyaciya/negoryuchaya-vata/karton-bazaltovyj'
    # doc = get_doc(product_link)
# p get_pict(doc)

  end
  task t: :environment do
    doc = get_doc('https://nkamin.ru/catalog/pechi-dlya-bani/everest/everest-inox-15-210-kovka')
    # doc = get_doc('https://nkamin.ru//catalog/pechi-dlya-bani/everest/everest-inox-20-280')
    p doc.css('.card_data_info .green, .card_data_info .red').text.strip rescue nil

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
  end
  #
  def get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  end
  #
  # def self.get_pict(doc)
  #   result = []
  #   doc_picts = doc.css('.slick-SliderCardNav img')
  #   if doc_picts.present?
  #     result = doc_picts.map do |doc_pict|
  #       "https://nkamin.ru#{doc_pict['src'].gsub("-100", "-600")}"
  #     end
  #   elsif doc.at('.SliderCard a')
  #     result << "https://nkamin.ru#{doc.at('.SliderCard a')['href']}"
  #   else
  #     nil
  #   end
  #   result.join(' ')
  # end

end
