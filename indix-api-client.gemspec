Gem::Specification.new do |s|
  s.name        = 'indix-api-client'
  s.version     = '0.0.1'
  s.date        = '2016-05-10'
  s.summary     = "Indix API Client library to interact with indix apis using ruby"
  s.description = "Indix API Client library to interact with indix apis using ruby"
  s.authors     = ["Jeevan"]
  s.email       = 'jeevan@indix.com'
  s.files       = ["lib/models.rb", "lib/exceptions.rb", "lib/http_client.rb", "lib/indix_api_client.rb"]
  s.homepage    = 'http://indix.com'
  s.license     = 'MIT'
	s.add_runtime_dependency 'rest-client',  '~>1.8' 
	s.add_runtime_dependency 'activesupport', '~>4.0'
	s.add_runtime_dependency 'hashie', '~>3.0'
  s.add_development_dependency 'rspec', '~>3.4.0'
end