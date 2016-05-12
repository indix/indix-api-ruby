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
		get_products(query, 'summary')
	end

	def get_offers_standard_products(query)
		get_products(query, 'offersStandard')
	end

	def get_offers_premium_products(query)
		get_products(query, 'offersPremium')
	end

	def get_catalog_standard_products(query)
		get_products(query, 'catalogStandard')
	end

	def get_catalog_premium_products(query)
		get_products(query, 'catalogPremium')		
	end

	def get_universal_products(query)
		get_products(query, 'universal')		
	end

	def get_summary_product_detail(product_id)
		get_product_detail(pid, 'summary')
	end

	def get_offers_standard_product_detail(product_id)
		get_product_detail(pid, 'offersStandard')
	end

	def get_offers_premium_product_detail(product_id)
		get_product_detail(pid, 'offersPremium')
	end

	def get_catalog_standard_product_detail(product_id)
		get_product_detail(pid, 'catalogStandard')
	end

	def get_catalog_premium_product_detail(product_id)
		get_product_detail(pid, 'catalogPremium')
	end				

	def get_universal_product_detail(product_id)
		get_product_detail(pid, 'universal')
	end

	def post_bulk_summary_products(query)
		post_bulk_search_job(query, 'summary')
	end

	def post_bulk_offers_standard_products(query)
		post_bulk_search_job(query, 'offersStandard')
	end

	def post_bulk_offers_premium_products(query)
		post_bulk_search_job(query, 'offersPremium')
	end

	def post_bulk_catalog_standard_products(query)
		post_bulk_search_job(query, 'catalogStandard')
	end

	def post_bulk_catalog_premium_products(query)
		post_bulk_search_job(query, 'catalogPremium')		
	end	

	def post_bulk_universal_products(query)
		post_bulk_search_job(query, 'universal')		
	end

	def post_bulk_summary_product_lookup(query)
		post_bulk_lookup_job(query, 'summary')
	end

	def post_bulk_offers_standard_product_lookup(query)
		post_bulk_lookup_job(query, 'offersStandard')
	end

	def post_bulk_offers_premium_product_lookup(query)
		post_bulk_lookup_job(query, 'offersPremium')
	end

	def post_bulk_catalog_standard_product_lookup(query)
		post_bulk_lookup_job(query, 'catalogStandard')
	end

	def post_bulk_catalog_premium_product_lookup(query)
		post_bulk_lookup_job(query, 'catalogPremium')		
	end	

	def post_bulk_universal_product_lookup(query)
		post_bulk_lookup_job(query, 'universal')		
	end

	private

	def get_products(query, type = 'summary')
		params = query.to_hash
		params.merge!(self.to_hash)
		http_client = get_http_client
		http_client.request("get", "/v2/#{type}/products", params)		
	end	

	def get_product_detail(product_id, type = 'summary')
		params = query.to_hash
		params.merge!(self.to_hash)
		http_client = get_http_client
		http_client.request("get", "/v2/#{type}/products/#{product_id}", params)		
	end	

	def post_bulk_search_job(query, type = 'summary')
		payload = query.to_hash
		payload.merge!(self.to_hash)
		http_client = get_http_client
		http_client.request("post", "/v2/#{type}/bulk/products", request_params, payload)   				
	end

	def post_bulk_lookup_job(query, type = 'summary')
		payload = query.to_hash
		payload.merge!(self.to_hash)
		request_params = {:multipart => true}		
		http_client = get_http_client
		http_client.request("post", "/v2/#{type}/bulk/lookup", request_params, payload)				
	end

	def get_http_client
		HttpClient.new(self.host, self.protocol)
	end
end