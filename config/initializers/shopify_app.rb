ShopifyApp.configure do |config|
  config.api_key = ENV['SHOPIFY_API_KEY']
  config.secret = ENV['SHOPIFY_SECRET']
  config.redirect_uri = "http://localhost:3000/auth/shopify/callback"
  config.scope = "read_content,write_content,read_themes,write_themes,read_products,write_products,read_customers,write_customers,read_orders,write_orders,read_script_tags,write_script_tags,read_fulfillments,write_fulfillments,read_shipping,write_shipping"
  config.embedded_app = false
end
