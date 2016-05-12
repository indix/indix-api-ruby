require 'http_client'
require 'models'

class IndixApiClient < ParamsBase
	attr_accessor :app_id, :app_key, :host, :protocol

	def initialize(app_id, app_key, host = "api.indix.com", protocol = "https")
		@app_id = app_id
		@app_key = app_key
		@host = host
		@protocol = protocol
	end

	def get_stores(query)
		params = query.to_hash
		params.merge!(self.to_hash)
		http_client = get_http_client
		http_client.request("get", "/v2/stores", params)		
	end

	def get_brands(query)
		params = query.to_hash
		params.merge!(self.to_hash)
		http_client = get_http_client
		http_client.request("get", "/v2/brands", params)		
	end

	def get_categories
		params = self.to_hash
		http_client = get_http_client
		http_client.request("get", "/v2/categories", params)		
	end

	def get_summary_products(query)
		params = query.to_hash
		params.merge!(self.to_hash)
		http_client = get_http_client
		http_client.request("get", "/v2/summary/products", params)		
	end	

	def get_offers_standard_products(query)
		params = query.to_hash
		params.merge!(self.to_hash)
		http_client = get_http_client
		http_client.request("get", "/v2/offersStandard/products", params)		
	end	

	def get_offers_premium_products(query)
		params = query.to_hash
		params.merge!(self.to_hash)
		http_client = get_http_client
		http_client.request("get", "/v2/offersPremium/products", params)		
	end

	def get_catalog_standard_products(query)
		params = query.to_hash
		params.merge!(self.to_hash)
		http_client = get_http_client
		http_client.request("get", "/v2/catalogStandard/products", params)		
	end

	def get_catalog_premium_products(query)
		params = query.to_hash
		params.merge!(self.to_hash)
		http_client = get_http_client
		http_client.request("get", "/v2/catalogPremium/products", params)		
	end	

	def get_universal_products(query)
		params = query.to_hash
		params.merge!(self.to_hash)
		http_client = get_http_client
		http_client.request("get", "/v2/universal/products", params)		
	end	

	private

	def get_http_client
		HttpClient.new(self.host, self.protocol)
	end
end