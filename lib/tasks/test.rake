namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task p: :environment do
    category_url = 'https://shulepov.ru/catalog/baki-iz-pishchevoy-nerzhaveyki/'
    doc = get_doc("#{category_url}?SHOWALL_1=1")
    # удаляем рекламный блок
    p doc.css('.bxr-list').count
    doc.css('.bxr-list').last.unlink
    p doc.css('.bxr-list').count
  end
  task t: :environment do

  end



  def get_pict(doc)
    result = []
    doc_picts = doc.css('.ax-element-slider-main a')
    if doc_picts.present?
      result = doc_picts.map do |doc_pict|
        "https://shulepov.ru#{doc_pict['href']}"
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

end
