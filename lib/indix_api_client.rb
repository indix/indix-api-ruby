require 'http_client'
require 'models'

class IndixApiClient < ParamsBase
	attr_accessor :app_id, :app_key, :host, :protocol, :http_client

	def initialize(app_id, app_key, host = "api.indix.com", protocol = "https")
		@app_id = app_id
		@app_key = app_key
		@host = host
		@protocol = protocol
		@http_client = get_http_client
	end

	def get_stores(query)
		params = query.to_hash
		params.merge!(get_api_params)
		self.http_client.request("get", "/v2/stores", params)		
	end

	def get_brands(query)
		params = query.to_hash
		params.merge!(get_api_params)
		self.http_client.request("get", "/v2/brands", params)		
	end

	def get_categories
		params = self.to_hash
		self.http_client.request("get", "/v2/categories", params)		
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

	def get_summary_product_detail(product_id, countryCode)
		get_product_detail(product_id, countryCode, 'summary')
	end

	def get_offers_standard_product_detail(product_id, countryCode)
		get_product_detail(product_id, countryCode, 'offersStandard')
	end

	def get_offers_premium_product_detail(product_id, countryCode)
		get_product_detail(product_id, countryCode, 'offersPremium')
	end

	def get_catalog_standard_product_detail(product_id, countryCode)
		get_product_detail(product_id, countryCode, 'catalogStandard')
	end

	def get_catalog_premium_product_detail(product_id, countryCode)
		get_product_detail(product_id, countryCode, 'catalogPremium')
	end				

	def get_universal_product_detail(product_id, countryCode)
		get_product_detail(product_id, countryCode, 'universal')
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

	def get_bulk_job_status(job_id)
		params = get_api_params
		self.http_client.request("get", "/v2/bulk/jobs/#{job_id}", params)		
	end	

	def get_bulk_job_output(job_id)
		params = get_api_params
		extra_options = {:stream => true}
		self.http_client.request("get", "/v2/bulk/jobs/#{job_id}/download", params, {}, extra_options)		
	end	

	def post_advanced_search_bulk_job(query)
		payload = query.to_hash
		payload.merge!(get_api_params)
		extra_options = {:multipart => true}		
		self.http_client.request("post", "/v2/universal/bulk/ase", {}, payload, extra_options)	
	end

	def get_advanced_search_bulk_job_status(job_id)
		params = get_api_params
		self.http_client.request("get", "/v2/bulk/ase/#{job_id}", params)	
	end

	def get_advanced_search_bulk_job_output(job_id)
		params = get_api_params
		extra_options = {:stream => true}
		self.http_client.request("get", "/v2/bulk/ase/#{job_id}", params, {}, extra_options)
	end

	def get_api_params
		{"app_id" =>  self.app_id, "app_key" => self.app_key}
	end

	def get_suggestions(country_code, q)
		params = get_api_params
		params.merge!({"countryCode" => country_code, "q" => q})
		self.http_client.request("get", "/v2/bulk/ase/#{job_id}", params)
	end

	def get_product_price_history(pid, query)
		params = query.to_hash
		params.merge!(get_api_params)
		self.http_client.request("get", "/v2/history/products/#{pid}", params)
	end

	private

	def get_products(query, type = 'summary')
		params = query.to_hash
		params.merge!(get_api_params)
		self.http_client.request("get", "/v2/#{type}/products", params)		
	end	

	def get_product_detail(product_id, country_code, type = 'summary')
		params = {"countryCode" => country_code}
		params.merge!(get_api_params)
		self.http_client.request("get", "/v2/#{type}/products/#{product_id}", params)		
	end	

	def post_bulk_search_job(query, type = 'summary')
		payload = query.to_hash
		payload.merge!(get_api_params)
		self.http_client.request("post", "/v2/#{type}/bulk/products", {}, payload)   				
	end

	def post_bulk_lookup_job(query, type = 'summary')
		payload = query.to_hash
		payload.merge!(get_api_params)
		extra_options = {:multipart => true}		
		self.http_client.request("post", "/v2/#{type}/bulk/lookup", {}, payload, extra_options)				
	end

	def get_http_client
		HttpClient.new(self.host, self.protocol)
	end

end