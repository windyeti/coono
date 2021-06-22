namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task p: :environment do
    # link = 'https://t-m-f.ru/catalog-new/model/komplektuyushchie_dlya_pechey/chugunnye_kruzhki/#1931'
    # link = 'https://t-m-f.ru/catalog-new/mod/lyuvers_f76_dotsent_inox/'
    # link = 'https://t-m-f.ru/catalog-new/mod/lyuvers_f57_inzhener_inox/'
    link = 'https://t-m-f.ru/catalog-new/model/komplektuyushchie_dlya_pechey/lyuversy_na_pechi/#1931'

    doc = rest_client_get(link)
    p doc.css('.price').text.gsub(/[а-яА-Я]|\*|\.|\s|₽|^0+/, "").strip rescue nil
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
