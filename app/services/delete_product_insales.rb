class Services::DeleteProductInsales
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def call
    api_key = Rails.application.secrets.api_key
    password = Rails.application.secrets.password
    domain = Rails.application.secrets.domain
    url_api_category = "http://#{api_key}:#{password}@#{domain}/admin/products/#{id}.json"

    RestClient.delete( url_api_category, :accept => :json, :content_type => "application/json") do |response, request, result, &block|
      case response.code
      when 200
        puts "sleep 0.5 #{id} товар удалили"
        sleep 0.5
        JSON.parse(response)
      when 422
        puts "error 422 - не удалили товар"
        JSON.parse(response)
      when 404
        puts 'error 404'
        JSON.parse(response)
      when 503
        sleep 1
        puts 'sleep 1 error 503'
        JSON.parse(response)
      else
        puts 'UNKNOWN ERROR'
      end
    end
  end
end
