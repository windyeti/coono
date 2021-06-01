json.extract! product, :id, :sku, :title, :desc, :cat, :oldprice, :price, :quantity, :image, :url, :lit_kom_id, :created_at, :updated_at
json.url product_url(product, format: :json)
