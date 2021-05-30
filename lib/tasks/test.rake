namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task t: :environment do
    doc = get_doc('https://lit-kom.ru/kaminy/kaminnye-topki/kaminnye-topki-lk/kaminnaya-topka-lk-elbrus-700-kontrgruz-litevoy-shamot/')
    p doc.at('.ty-product-block__price-actual .ty-price-num').text.strip.gsub(" ", "")

  end

  # def get_doc(url)
  #   category_url = URI.escape(url)
  #   Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  # end
  #
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
