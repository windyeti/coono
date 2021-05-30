namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task t: :environment do
    doc = get_doc('https://lit-kom.ru/dymohody-baki-dlya-vody/bak-nerzhaveyka-60l-pod-kontur-gorizontal-ovalnyy-aisi-430/')
    p desc = doc.at('#content_description').inner_html.truncate(25) rescue nil
  end

  def get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  end

  def get_pict(doc)
    result = []
    doc_picts = doc.css('.ty-product-thumbnails.ty-center.cm-image-gallery img')
    if doc_picts.present?
      result = doc_picts.map do |doc_pict|
        doc_pict['src'].gsub('/thumbnails/55/55', '').gsub('.png','')
      end
    elsif doc.at('.ty-product-bigpicture__img img')
      result << doc.at('.ty-product-bigpicture__img img')['src']
    end
    result.join(' ')
  end

end
