namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task q: :environment do
    link = "https://sawo.ru/product/montazhnyy-flanets-dlya-pechi-tower-th2-th3-stal-art-th-collar-st2-cnr"
    link2 = "https://sawo.ru/product/sawo-elektricheskaya-pech-aries-napolnaya-pristennaya-bez-pulta-vstr-blok-moschnosti-90-kvt-nerzh-stal-artikul-ari3-90ni2-wl-p"
    doc = get_doc(link)
    doc2 = get_doc(link2)
    p doc.at('.availability').text.strip == "В наличии" ? "100" : "0"
  end

  task h: :environment do
    get_reviews
  end

  task t: :environment do
      # link = "https://www.wellfitness.ru/index.php?route=product/product&path=103_104&product_id=843"
      link = "https://www.wellfitness.ru/index.php?route=product/product&path=62&product_id=308"
      doc = get_doc(link)
      p doc.at('input[name="product_id"]')['value']
  end

  task p: :environment do
    # doc = get_doc "https://dantexgroup.ru/catalog-kamin/get_content.php?3&?sflt=1&sectID=1281"
    link = "https://dantexgroup.ru/catalog/kaminy/elektrokaminy/portaly/dimplex/"
    sectID = get_doc(link).css('.wrapper script').last.text.match(/\/\/\svar\slistData\s=\s'\?sflt=1&sectID=\d+';$/).to_s.split('=').last.gsub("';","")
    doc = rest_client_get "https://dantexgroup.ru/catalog-kamin/get_content.php?3&?sflt=1&sectID=#{sectID}&&SHOWALL_1=1"
    p doc.css('li a').map {|a| a['href']}
  end

  # def get_pict(doc)
  #   result = []
  #   doc_picts = doc.css('#example1 a')
  #   if doc_picts.present?
  #     result = doc_picts.map do |doc_pict|
  #       doc_pict['href']
  #     end
  #   else
  #     nil
  #   end
  #   result.join(' ')
  # end

  def get_quantity(doc)
    doc.at(".product-label") && doc.at(".product-label").text == "Распродано" ? "0" : "100"
  end

  def get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  end

  def get_products
    page = 1

    # loop do
      list_resp = RestClient.get "http://#{Rails.application.secrets.api_key}:#{Rails.application.secrets.password}@#{Rails.application.secrets.domain}/admin/products.json?page=#{page}&per_page=250}"
      sleep 0.5
      list_data = JSON.parse(list_resp.body)
      p list_data.count

      # list_data.each do |product|
        get_product(list_data.last["id"])
      # end

      # break if list_data.count == 0
      # page += 1
    # end
  end

  def get_product(id)
    id_product = id
    url_api_category = "http://#{Rails.application.secrets.api_key}:#{Rails.application.secrets.password}@#{Rails.application.secrets.domain}/admin/products/#{id_product}.json"

    RestClient.get( url_api_category, :accept => :json, :content_type => "application/json") do |response, request, result, &block|
      case response.code
      when 200
        puts "sleep 0.5 #{id_product} товар"
        sleep 0.5
        pp JSON.parse(response.body)
      when 422
        puts "error 422"
        puts response
      when 404
        puts 'error 404'
        puts response
      when 503
        sleep 1
        puts 'sleep 1 error 503'
      else
        puts 'UNKNOWN ERROR'
      end
    end
  end

  def get_reviews
    uri = "http://#{Rails.application.secrets.api_key}:#{Rails.application.secrets.password}@#{Rails.application.secrets.domain}/admin/reviews.json"

    RestClient.get( uri, :accept => :json, :content_type => "application/json") do |response, request, result, &block|
      case response.code
      when 200
        puts "sleep 0.5"
        sleep 0.5
        pp JSON.parse(response.body)
        pp JSON.parse(response.body).count
      when 422
        puts "error 422"
        puts response
      when 404
        puts 'error 404'
        puts response
      when 503
        sleep 1
        puts 'sleep 1 error 503'
      else
        puts 'UNKNOWN ERROR'
      end
    end
  end
end
