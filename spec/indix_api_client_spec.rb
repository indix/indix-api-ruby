require 'indix_api_client'
require 'http_client'

load 'spec_helper.rb'

describe IndixApiClient, :type => :class do
	before(:each) do
		host = "localhost"
		protocol = "http"
		@iac = IndixApiClient.new("app_id", "app_key", host, protocol)
		@http_client = HttpClient.new(host, protocol)
		@iac.http_client = @http_client
	end

	describe "test client settings" do
		it "should return default settings" do
			iac = IndixApiClient.new("app_id", "app_key")
			iac.app_id.should eq("app_id")
			iac.app_key.should eq("app_key")
			iac.host.should eq("api.indix.com")
			iac.protocol.should eq("https")
		end

		it "should override client settings" do
			iac = IndixApiClient.new("app_id", "app_key", "localhost", "http")
			iac.app_id.should eq("app_id")
			iac.app_key.should eq("app_key")
			iac.host.should eq("localhost")
			iac.protocol.should eq("http")
		end
	end

	describe "test bcs lookup endpoints" do
		it "should return stores" do
			data = load_fixture "stores.json"
			@http_client.stub(:get).with("http://localhost/v2/stores?q=amazon&app_id=app_id&app_key=app_key").and_return(data)		
			bqp = BCSQueryParams.new
			bqp.q="amazon"
			output = @iac.get_stores(bqp)
			output.should eq({"message"=>"ok", "result"=>{"stores"=>[{"id"=>270, "name"=>"Amazon.com Marketplace", "countryCode"=>"US"}]}})
		end
	end

	describe "test product search endpoints" do
		it "should return products" do
			data = load_fixture "product-search.json"
			@http_client.stub(:get).with("http://localhost/v2/summary/products?q=nike&app_id=app_id&app_key=app_key").and_return(data)		
			bqp = SearchParams.new
			bqp.q="nike"
			output = @iac.get_summary_products(bqp)
			output["message"].should eq("ok")
			output["result"]["products"].length.should eq(10)
			output["result"]["products"][0].should eq({"categoryNamePath"=>"Shoes > Men > Fashion Sneakers", "categoryId"=>20082, "mpid"=>"8e1d8cd338ada38624d2f9322b259402", "categoryName"=>"Fashion Sneakers", "upcs"=>["00884499652748", "00091206081795", "00091206081818", "00884499652755"], "brandName"=>"Nike", "minSalePrice"=>45.02, "brandId"=>5572, "categoryIdPath"=>"10179 > 17421 > 20082", "mpns"=>["ROSHERUN", "511881-405"], "countryCode"=>"US", "currency"=>"USD", "title"=>"Nike Men's Rosherun Running Shoe.", "lastRecordedAt"=>1462486236868, "imageUrl"=>"http://ecx.images-amazon.com/images/I/41N3coiimrL._AA200_.jpg", "maxSalePrice"=>162.0, "offersCount"=>212, "storesCount"=>1})
			output["result"]["products"][1].should eq({"categoryNamePath"=>"Shoes > Women > Athletic > Running", "categoryId"=>24323, "mpid"=>"7c6ad2c5168590a2cdfc6d1335e764f4", "categoryName"=>"Running", "upcs"=>[], "brandName"=>"Nike", "minSalePrice"=>51.05, "brandId"=>5572, "categoryIdPath"=>"10179 > 16238 > 16239 > 24323", "mpns"=>["709021 016", "709021 501"], "countryCode"=>"US", "currency"=>"USD", "title"=>"Nike Women's Flex 2015 Rn Running Shoe", "lastRecordedAt"=>1462672038790, "imageUrl"=>"http://ecx.images-amazon.com/images/I/810L5hTOJQL._UX500_.jpg", "maxSalePrice"=>99.99, "offersCount"=>99, "storesCount"=>4})
		end
	end	

	describe "test product lookup endpoints" do
		it "should return product details" do
			data = load_fixture "product-detail.json"
			@http_client.stub(:get).with("http://localhost/v2/summary/products/8e1d8cd338ada38624d2f9322b259402?countryCode=US&app_id=app_id&app_key=app_key").and_return(data)		
			bqp = SearchParams.new
			bqp.q="nike"
			output = @iac.get_summary_product_detail("8e1d8cd338ada38624d2f9322b259402", "US")
			output.should eq({"message"=>"ok", "result"=>{"product"=>{"categoryNamePath"=>"Shoes > Men > Fashion Sneakers", "categoryId"=>20082, "mpid"=>"8e1d8cd338ada38624d2f9322b259402", "categoryName"=>"Fashion Sneakers", "upcs"=>["00884499652748", "00091206081795", "00091206081818", "00884499652755"], "brandName"=>"Nike", "minSalePrice"=>45.02, "brandId"=>5572, "categoryIdPath"=>"10179 > 17421 > 20082", "mpns"=>["ROSHERUN", "511881-405"], "countryCode"=>"US", "currency"=>"USD", "title"=>"Nike Men's Rosherun Running Shoe.", "lastRecordedAt"=>1462486236868, "imageUrl"=>"http://ecx.images-amazon.com/images/I/41N3coiimrL._AA200_.jpg", "maxSalePrice"=>162, "offersCount"=>212, "storesCount"=>1}}})
		end
	end		

	describe "test bulk job endpoints" do
		it "should submit bulk lookup job" do
			data = load_fixture "bulk-job.json"
			@http_client.stub(:post).with("http://localhost/v2/summary/bulk/lookup", an_instance_of(Hash)).and_return(data)		
			bqp = BulkProductLookupParams.new
			bqp.countryCode="US"
			bqp.file=File.new(File.dirname(__FILE__) + "/fixtures/upcs.json")
			output = @iac.post_bulk_summary_product_lookup(bqp)	
			output.should eq({"message" => "ok", "result" => {"jobId" => "1234", "status" => "SUBMITTED"}})
		end

		it "should submit bulk search job" do
			data = load_fixture "bulk-job.json"
			@http_client.stub(:post).with("http://localhost/v2/summary/bulk/products", "countryCode=US&storeId=1001&app_id=app_id&app_key=app_key").and_return(data)		
			bqp = BulkProductSearchParams.new
			bqp.countryCode="US"
			bqp.storeId=[1001]
			output = @iac.post_bulk_summary_products(bqp)	
			output.should eq({"message" => "ok", "result" => {"jobId" => "1234", "status" => "SUBMITTED"}})
		end

		it "should get job status" do
			data = load_fixture "bulk-job.json"
			@http_client.stub(:get).with("http://localhost/v2/bulk/jobs/1234?app_id=app_id&app_key=app_key").and_return(data)		
			output = @iac.get_bulk_job_status("1234")
			output.should eq({"message" => "ok", "result" => {"jobId" => "1234", "status" => "SUBMITTED"}})
		end

		it "should get job output" do
			data = load_fixture "bulk-job-output.json"
			@http_client.stub(:get).with("http://localhost/v2/bulk/jobs/1234/download?app_id=app_id&app_key=app_key").and_return(data)		
			output = @iac.get_bulk_job_output("1234")
			output.should eq("{\"input\":\"{\"upc\": \"10264586899\"}\",\"status\":200,\"count\":2,\"product\":{\"minSalePrice\":97.95,\"maxSalePrice\":443.75,\"offersCount\":7,\"storesCount\":3,\"lastRecordedAt\":1429571378687,\"countryCode\":\"US\",\"mpid\":\"daa0e0cda1e831c7a1d8503f712ce627\",\"currency\":\"USD\",\"upcs\":[\"00010264586899\"],\"title\":\"HP - 146 GB 2.5\" Internal Hard Drive\",\"brandId\":1598,\"categoryIdPath\":\"10161 > 16639 > 17260 > 24698\",\"brandName\":\"Hewlett-Packard\",\"categoryId\":24698,\"categoryName\":\"Computer Components\",\"mpns\":[\"418399-001 - A1381\"],\"imageUrl\":\"http://images.bestbuy.com/BestBuy_US/images/mp/products/1305/1305850/1305850512/1305850512_105x210_sc.jpg\",\"categoryNamePath\":\"Computers & Accessories > Data Storage > Internal Hard Drives > Computer Components\"}}\n{\"input\":\"{\"upc\": \"10264586899\"}\",\"status\":200,\"count\":2,\"product\":{\"minSalePrice\":17.88,\"maxSalePrice\":292.0,\"offersCount\":22,\"storesCount\":11,\"lastRecordedAt\":1462763904901,\"countryCode\":\"US\",\"mpid\":\"0506209471c9821a8332339940bf189f\",\"currency\":\"USD\",\"upcs\":[\"00010264586899\"],\"title\":\"HP Proliant 432320-001 SAS Hard Drive 146GB 10K 2.5\" Single Port in Tray\",\"brandId\":1598,\"categoryIdPath\":\"10161 > 16639 > 17260 > 24698\",\"brandName\":\"Hewlett-Packard\",\"categoryId\":24698,\"categoryName\":\"Computer Components\",\"mpns\":[\"432320001\",\"432320-001\"],\"imageUrl\":\"http://ecx.images-amazon.com/images/I/51PJghWlekL._SX466_.jpg\",\"categoryNamePath\":\"Computers & Accessories > Data Storage > Internal Hard Drives > Computer Components\"}}")
		end				
	end
end
