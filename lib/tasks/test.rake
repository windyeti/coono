namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task p: :environment do
    # doc = get_doc 'https://saunaru.com/product/harvia-elektricheskaya-pech-wall-hsw450400m-sw45-chernaya'
    doc = get_doc 'https://saunaru.com/product/saunaru-dver-profi-bronza-200h80'

  end

  task t: :environment do

  end

  def get_pict(doc)
    result = []
    doc_picts = doc.css('.product-gallery a')
    if doc_picts.present?
      result = doc_picts.map do |doc_pict|
        doc_pict['href']
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
