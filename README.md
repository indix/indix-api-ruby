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

##To Get Stores 
```ruby
ixc = IndixApiClient.new("app_id", "app_key")
query = BCSQueryParams.new
query.q="nike"
ixc.get_stores(query)
```

