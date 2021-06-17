namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task p: :environment do
    link = 'https://realflame.ru/kaminnye-drovniki/9-10000bk-drovnik'

    doc = get_doc(link)
    p get_pict(doc)
  end
  task t: :environment do

  end
  # def get_pict(doc)
  #   result = []
  #   doc_picts = doc.css('#thumbs_list_frame a')
  #   if doc_picts.present?
  #     result = doc_picts.map do |doc_pict|
  #       doc_pict['href']
  #     end
  #   elsif doc.at('#bigpic')
  #     result << doc.at('#bigpic')['src']
  #   end
  #   result.join(' ')
  # end
  #
  # def get_doc(url)
  #   category_url = URI.escape(url)
  #   Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  # end

end
