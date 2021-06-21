namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task p: :environment do
    link = 'https://realflame.ru/kaminnye-drovniki/9-10000bk-drovnik'

    doc = rest_client_get(link)
    p get_pict(doc)
  end

  task t: :environment do

  end

  def get_pict(doc)
    result = []
    doc_picts = doc.css('.wrapp_thumbs li')
    if doc_picts.present?
      result = doc_picts.map do |doc_pict|
        "https://t-m-f.ru#{doc_pict['data-big_img']}" if doc_pict['data-big_img'].present?
      end
    elsif doc.at('.item_main_info img')
      result << "https://t-m-f.ru#{doc.at('.item_main_info img')['src']}"
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
