require 'http_client'
require 'models'

class IndixApiClient < Base
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

	private

	def get_http_client
		HttpClient.new(self.host, self.protocol)
	end
end