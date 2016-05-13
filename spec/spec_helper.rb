require 'bundler/setup'
Bundler.setup

RSpec.configure do |config|
  
end

def load_fixture file_name
	File.read(File.dirname(__FILE__) + "/fixtures/#{file_name}")
end

def to_hashie json
  if json.is_a? Array
    json.collect! { |x| x.is_a?(Hash) ? Hashie::Mash.new(x) : x }
  else
    Hashie::Mash.new(json)
  end
end