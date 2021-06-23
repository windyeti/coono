namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task p: :environment do
    # doc = get_doc 'https://dimplex.ru/catalog/ochag-revillusion-rlg20/'
    doc = get_doc 'https://dimplex.ru/catalog/otdelnostoyashchie-ochagi/'
    p get_pict(doc)
    # p price = doc.at('#combo-price') ? doc.at('#combo-price .price > span').text.strip.gsub(/\s/,'') : doc.at('#price .price > span').text.strip.gsub(/\s/,'')

    # p title = doc.at('.hdr-block.def h1').text.strip
    # p desc = doc.at('#fld-desc').inner_html.strip

    # p props = if doc.at('#paramList')
    #               doc_text_block = doc.at('#paramList')
    #               result = []
    #               doc_dts = doc_text_block.css('dt')
    #               doc_dds = doc_text_block.css('dd')
    #               doc_dts.each_with_index { |doc_dt, index| result << "#{doc_dt.text.strip}: #{doc_dds[index].text.strip}"}
    #               result.join(' --- ')
    #           else
    #             nil
    #           end
  end

  task t: :environment do
    doc = get_doc('https://dimplex.ru/map')
    p doc.css('.content.black-link > ul > li:nth-child(1) > ul > li > a').map(&:text)
    # p doc.css('.content.black-link > ul > li.first-child li')
  end

  def get_pict(doc)
    result = []
    doc_picts = doc.css('.prod-thumb a')
    if doc_picts.present?
      result = doc_picts.map do |doc_pict|
        url = doc_pict['href']
        url[/http|https/] ? url : "https://dimplex.ru#{url}"
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
