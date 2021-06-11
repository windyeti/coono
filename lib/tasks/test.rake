namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task p: :environment do
    product_link = 'https://nkamin.ru/catalog/tovary-dlya-montazha/termoizolyaciya/negoryuchaya-vata/karton-bazaltovyj'
    # doc = get_doc(product_link)
# p get_pict(doc)

  end
  task t: :environment do
    # url = 'https://t-m-f.ru/catalog-new/model/pechi_dlya_bani_1/variata_barrel_inox/#1931'
    # url = 'https://t-m-f.ru/catalog-new/model/mangaly_grili_koptilni_1/grili_1/barabek_/'
    # p doc = rest_client_get(url)

    # p doc = get_doc('https://t-m-f.ru/catalog-new/model/pechi_dlya_bani_1/variata_barrel_inox/#1931')
    # p doc = get_doc('https://t-m-f.ru/catalog-new/pechi_dlya_bani_1/variata_barrel_inox/')
    # response = RestClient::Request.execute(:url => 'https://t-m-f.ru/catalog-new/model/pechi_dlya_bani_1/variata_barrel_inox/#1931', :timeout => 100, :method => :get, :verify_ssl => false)
    # begin
    # p result = Nokogiri::HTML(JSON.parse(response.body))
    # rescue
    #   p 'EXEPTION!!!'
    # end
    # p result

    # p get_pict(doc)
    #
    call
  end

  def get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  end

  # def rest_client_get(url)
  #   response = RestClient.get(url)
  #   Nokogiri::HTML(response.body)
  # end

  # def rest_client_get(url)
  #   result_body = ''
  #   RestClient.get(url) do |response, request, result, &block|
  #     p response.code
  #     case response.code
  #     when 200
  #       puts 'sleep 0.3 категорию добавили'
  #       sleep 0.3
  #       result_body = Nokogiri::HTML(response.body)
  #       # result_body = JSON.parse(response.body)
  #     when 422
  #       puts "error 422 - не добавили категорию"
  #       puts response
  #     when 404
  #       puts 'error 404'
  #       puts response
  #     when 503
  #       sleep 1
  #       puts 'sleep 1 error 503'
  #     else
  #       response.return!(&block)
  #     end
  #   end
  #   result_body
  # end
  #
  # def self.get_pict(doc)
  #   result = []
  #   doc_picts = doc.css('.wrapp_thumbs li')
  #   if doc_picts.present?
  #     result = doc_picts.map do |doc_pict|
  #       "https://t-m-f.ru#{doc_pict['data-big_img']}" if doc_pict['data-big_img'].present?
  #     end
  #   elsif doc.at('.item_main_info img')
  #     result << "https://t-m-f.ru#{doc.at('.item_main_info img')['src']}"
  #   else
  #     nil
  #   end
  #   result.reject(&:nil?).join(' ')
  # end

end
