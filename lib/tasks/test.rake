namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL


  task t: :environment do
      link = "https://dantexgroup.ru/catalog/kaminy/elektrokaminy/ochagi/klassicheskie/royal-flame/ochag-fobos-fx-m-black-rlf/"
      # link = "https://dantexgroup.ru/catalog/kaminy/elektrokaminy/portaly/derevyannye/royal-flame/kaminokomplekt-dallas-60-slonovaya-kost-s-patinoy-rlf-s-ochagom-vision-60-log-led-rlf-26994/"
      doc = get_doc(link)

  p get_price(doc)
  end
  # def get_price(doc)
  #   price = doc.at('.price > span').text.strip.gsub(/\s| | /, "").to_i rescue nil
  #   if doc.at('h1').text.strip[/^Каминокомплект/]
  #     curComboID = doc.css('.wrapper script')[1]
  #                    .text
  #                    .match(/var\scurComboID\s=\s\d+;/).to_s.split('=').last.gsub(/'|;|\s/,"")
  #     combo_price = doc.at("#prod-list li[data-rel='#{curComboID}'] .price-block > .price")['data-price'].to_i
  #     price = price + combo_price
  #   end
  #   price
  # end

  task p: :environment do
    # doc = get_doc "https://dantexgroup.ru/catalog-kamin/get_content.php?3&?sflt=1&sectID=1281"
    link = "https://dantexgroup.ru/catalog/kaminy/elektrokaminy/portaly/dimplex/"
    sectID = get_doc(link).css('.wrapper script').last.text.match(/\/\/\svar\slistData\s=\s'\?sflt=1&sectID=\d+';$/).to_s.split('=').last.gsub("';","")
    doc = rest_client_get "https://dantexgroup.ru/catalog-kamin/get_content.php?3&?sflt=1&sectID=#{sectID}&&SHOWALL_1=1"
    p doc.css('li a').map {|a| a['href']}
  end
  #
  # def rest_client_get(url)
  #   response = RestClient.get(url)
  #   Nokogiri::HTML(response.body)
  # end
  # def get_price(doc)
  #   p price = doc.at('.box .price > span').text.strip.gsub(/\s| | /, "").to_i rescue nil
  #   if doc.at('h1').text.strip[/^Каминокомплект/]
  #     curComboID = doc.css('.wrapper script')[1]
  #                    .text
  #                    .match(/var\scurComboID\s=\s\d+;/).to_s.split('=').last.gsub(/'|;|\s/,"")
  #     p combo_price = doc.at("#prod-list li[data-rel='#{curComboID}'] .price-block > .price")['data-price'].to_i
  #     curOfferID = doc.css('.wrapper script')[1]
  #                 .text
  #                 .match(/var\scurOfferID\s=\s\d+;/).to_s.split('=').last.gsub(/'|;|\s/,"")
  #     price = doc.at("#offer-list div.offer[data-id='#{curOfferID}']")['data-price'].to_i
  #     price = price + combo_price
  #   elsif doc.at('h1').text.strip[/^Портал/]
  #     curOfferID = doc.css('.wrapper script')[1]
  #                    .text
  #                    .match(/var\scurOfferID\s=\s\d+;/).to_s.split('=').last.gsub(/'|;|\s/,"")
  #     price = doc.at("#offer-list div.offer[data-id='#{curOfferID}']")['data-price'].to_i
  #   end
  #   price
  # end

  # def get_doc(url)
  #   category_url = URI.escape(url)
  #   Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  # end
  # #
  #   def get_images(doc)
  #     doc_images = doc.css('.prod-thumb a')
  #     if doc_images.present?
  #       doc_images.map  do |a|
  #         "https://dantexgroup.ru#{a['data-image']}" unless a.attribute('class').value[/video|d3/]
  #       end.reject(&:nil?).join(' ')
  #     end
  #   end
end
