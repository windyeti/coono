namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task p: :environment do
    doc = get_doc 'https://contactplus.ru/catalog/pech-dlya-sauny-iki-uglovaya.html'
# p doc.at('.card-page-product-price-block__price')
p doc.at('title')

  end

  task t: :environment do
    doc = rest_client_get 'https://contactplus.ru/catalog/pech-dlya-sauny-tylo-sense-commercial.html'
    p get_data_products(doc)
  end

  # def get_doc(url)
  #   category_url = URI.escape(url)
  #   Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 240, :method => :get, :verify_ssl => false))
  # end
  #
  # def self.rest_client_get(url)
  #   response = RestClient.get(url)
  #   Nokogiri::HTML(response.body)
  # end
  #
  # def get_data_products(doc)
  #   result = []
  #   doc_table = doc.at('.item-table')
  #   doc_table_headers = doc_table.css('.itable-header td')
  #   table_headers = {}
  #   doc_table_headers.each do |doc_table_header|
  #     table_headers[doc_table_header.attribute('class').value] = "#{doc_table_header.text.strip}"
  #   end
  #   doc_trs = doc_table.css('tr:not(.itable-header):not(.sub-row)')
  #   doc_trs.each do |doc_tr|
  #     next if doc_tr.at("td[colspan='8']")
  #     product = {}
  #     table_headers.map do |key, name|
  #       value = doc_tr.at(".#{key}").text.strip rescue next
  #       product[name] = value
  #     end
  #     result << product
  #   end
  #   result
  # end

end
