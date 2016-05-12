class ParamsBase
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