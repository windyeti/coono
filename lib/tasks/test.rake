namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task p: :environment do
    doc = get_doc 'https://dimplex.ru/catalog/otdelnostoyashchie-ochagi/'
    p doc.css('.loader ul')
    # p doc.css('#append-list ul li > div > a')
    # p product_urls = doc.css('#append-list ul li > div > a').map {|a| "https://dimplex.ru#{a['href']}"}

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
