# indix-api-ruby
Ruby client for indix API


Installation
------------
```ruby 
gem install indix-api-client
```


To load the library
-------------------
```ruby 
require 'indix_api_client'
```

##Initialize Api Client
```ruby
IndixApiClient.new("app_id", "app_key")
```

##BCS Lookup
##To Get Stores 
```ruby
ixc = IndixApiClient.new("app_id", "app_key")
query = BCSQueryParams.new
query.q="nike"
ixc.get_stores(query)
```

##Product Search
##To get summary products
```ruby
ixc = IndixApiClient.new("app_id", "app_key")
query = SearchParams.new
query.q="nike"
query.countryCode="US"
query.storeId=[24]
ixc.get_products(query)
```

##Product Detail
##To get summary product detail
```ruby
ixc = IndixApiClient.new("app_id", "app_key")
ixc.get_summary_product_detail("pid")
```

##Bulk Product Lookup
##To post bulk summary product lookup
```ruby
ixc = IndixApiClient.new("app_id", "app_key")
query = BulkProductLookupParams.new
query.countryCode="US"
query.file=File.new("---path----")
ixc.post_bulk_summary_product_lookup(query)
```

##Bulk Product Search
##To post bulk product summary search
```ruby
ixc = IndixApiClient.new("app_id", "app_key")
query = BulkProductSearchParams.new
query.countryCode="US"
query.q="nike"
ixc.post_bulk_summary_products(query)
```