class HomeController < AuthenticatedController
  def index
  end

  def infest
    install_alert_blocker

    5.times { create_infested_product }
    5.times { create_infested_customer }
  end

  private

  STOREFRONT_ALERT_BLOCKER = %q(

  <!-- Block storefront alerts from Shop of Horrors ====================== -->
  <script>
    function alert(s) {
      console.log("Suppressed alert: " + s);
    }
  </script>
)

  def install_alert_blocker
    main_theme = ShopifyAPI::Theme.find(:all, params: {role: 'main'}).first
    asset = ShopifyAPI::Asset.find('layout/theme.liquid', params: {theme_id: main_theme.id})
    unless asset.value.include?('Shop of Horrors')
      asset.value[asset.value.index('<head>')+6] = STOREFRONT_ALERT_BLOCKER
      asset.save
    end
  end

  def create_infested_product
    product = ShopifyAPI::Product.new
    product.title = xss
    product.body_html = xss
    product.product_type = xss
    product.vendor = xss
    product.tags = [xss, xss]
    product.variants = [{
      price: 1.23,
      title: xss,
      option1: xss,
      inventory_management: 'shopify',
      sku: xss,
      barcode: xss,
    }]
    product.save
  end

  def create_infested_customer
    customer = ShopifyAPI::Customer.new
    customer.email = xss_email
    customer.note = xss
    customer.tags = [xss, xss]
    customer.save
  end

  def alert_count
    @alert_count = @alert_count.to_i + 1
  end

  def xss
    case rand(3)
    when 0
      "<script>alert(#{alert_count})</script>"
    when 1
      "\"><script>alert(#{alert_count})</script>"
    when 2
      "'+alert(#{alert_count})+'"
    end
  end

  def xss_email
    "<img/src=x/onerror=alert(#{alert_count})>@shopify.com"
  end

  def xss_amount
    "{{amount}} #{xss}"
  end
end
