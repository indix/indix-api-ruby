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
ixc.get_summary_products(query)
```