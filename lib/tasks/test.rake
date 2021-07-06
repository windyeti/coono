namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task p: :environment do
    doc = get_doc 'https://www.teplodar.ru/catalog/detail/kuban_20_l_panorama/'
p doc.at('.card-page-product-price-block__price').text.strip.gsub(/\s|&nbsp;| |руб./, "")

  end

  task t: :environment do
    url_catalog = "https://www.teplodar.ru/catalog/section/otopitelnye-kotly/"
    doc = get_doc url_catalog
    p button = doc.at('.js-show-more')
    p count_pages = button['data-page-cnt'].to_i
    p catalog_query = button['data-uid']
    links = []
    links += doc.css('.product-item-detail__name a').map{|item| "https://www.teplodar.ru#{item['href']}"}
    (2..count_pages).each do |count_page|
      url = "#{url_catalog}?AJAX_PAGER=1&PAGEN_1=#{count_page}&UID=#{catalog_query}"
      doc = get_doc(url)
      links += doc.css('.product-item-detail__name a').map{|item| "https://www.teplodar.ru#{item['href']}"}
    end
    p links, links.count
  end

  def get_pict(doc)
    result = []
    doc_picts = doc.css('.card-page-product-slider-thumbs .card-page-product-slider-thumbs-item-image img')
    if doc_picts.present?
      result = doc_picts.map do |doc_pict|
        p h = doc_pict['data-src'].split("/")
        href = "/#{h[1]}/#{h[3]}/#{h[4]}/#{h[6]}"
        "https://www.teplodar.ru#{href}"
      end
    else
      ""
    end
    result.join(' ')
  end

  def get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 240, :method => :get, :verify_ssl => false))
  end

end
