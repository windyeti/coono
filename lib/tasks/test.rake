namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task p: :environment do
    doc = get_doc "https://teplomarket-m.ru/dlya-bani/elektropechi-elektrokamenki-pechi-dlia-bani-i-sauny/pechi-harvia/harvia-alfa/elektricheskaya-pech-harvia-alfa-a30-steel"
    p doc.at('.product-title-row h1').text.strip
  end

    # doc.at('#combo-price .price span').text.strip
    # p title = doc.at('.hdr-block.def h1').text.strip
    #
    #
    #
    #
    # p p1 = if doc.at('#paramList')
    #        doc_text_block = doc.at('#paramList')
    #        result = []
    #        doc_dts = doc_text_block.css('dt')
    #        doc_dds = doc_text_block.css('dd')
    #        doc_dts.each_with_index { |doc_dt, index| result << "#{doc_dt.text.strip}: #{doc_dds[index].text.strip}"}
    #        result.join(' --- ')
    #      else
    #        nil
    #      end
    #
    # p pict = get_pict(doc)
    #
    # p desc = doc.at('#fld-desc').inner_html.strip rescue nil


    # if doc.at('.hdr-block.def h1').text.strip.include?("Каминокомплект")
    #   p price = doc.at('#combo-price .price span').text.strip rescue nil
    # else
    #   p price = doc.at('meta[itemprop="price"]')['content'] rescue nil
    # end




  # def get_pict(doc)
  #   result = []
  #   doc_picts = doc.css('.sku__gallery a')
  #   if doc_picts.present?
  #     result = doc_picts.map do |doc_pict|
  #       doc_pict['href']
  #     end
  #   else
  #     nil
  #   end
  #   result.join(' ')
  # end

  def get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
  end

  # task t: :environment do

  # end

end
