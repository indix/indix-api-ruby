class ParamsBase
	def initialize params={}
    params.each { |k, v| send "#{k}=", v }
  end

	def to_hash
		hash = {}
		self.instance_variables.each do |var| 
			hash[var.to_s.delete("@")] = self.instance_variable_get(var) 
		end
		hash
	end
end

class BCSQueryParams < ParamsBase
	attr_accessor :q
end

class BulkProductLookupParams < ParamsBase
	attr_accessor :countryCode, :file
end

class BulkProductSearchParams < ParamsBase
	attr_accessor :countryCode, :storeId, :alsoSoldAt, :brandId, :categoryId
	attr_accessor :startPrice, :endPrice, :availability, :priceHistoryAvailable, :priceChange
	attr_accessor :onPromotion, :lastRecordedIn, :storesCount, :applyFiltersTo, :selectOffersFrom
end

class SearchParams < BulkProductSearchParams
	attr_accessor :q, :url, :upc, :mpn, :sku
	attr_accessor :sortBy, :facetBy, :pageNumber, :pageSize
end

class PriceHistoryParams < ParamsBase
	attr_accessor :countryCode, :storeId
end
