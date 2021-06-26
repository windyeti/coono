namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task p: :environment do
    doc = get_doc 'https://sawo.ru/product/sawo-parogenerator-bez-pulta-upravleniya-35-kvt-stn-35-12-x'
    p sku = doc.at('.product-sku').text.gsub("Артикул: ", "").strip rescue nil

      # p doc.at('.gallery-large_image a')['href']
# p get_pict(doc)
  end

  task t: :environment do

  end

  # def get_pict(doc)
  #   result = []
  #   doc_picts = doc.css('.gallery-preview_list a')
  #   if doc_picts.present?
  #     result = doc_picts.map do |doc_pict|
  #       doc_pict['href']
  #     end
  #   elsif doc.at('.gallery-large_image a')
  #     result << doc.at('.gallery-large_image a')['href']
  #   else
  #     nil
  #   end
  #   result.join(' ')
  # end
  #
  # def get_doc(url)
  #   category_url = URI.escape(url)
  #   Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  # end

end
