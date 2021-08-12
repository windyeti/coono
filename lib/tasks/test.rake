namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task p: :environment do
    p 'PRINT TEST!'
  end

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
end
