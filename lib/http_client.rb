require 'exceptions'
require 'rest_client'
require 'uri'
require 'hashie'
require 'active_support'

class HttpClient
  attr_accessor :host, :protocol, :headers
  
  def initialize(host, protocol = 'https')
    @host = host
    @protocol = protocol
    @headers = {}
  end

  def set_headers(hash)
    @headers = @headers.merge(hash)
  end

  def request(method, path, request_params = {}, payload = {}, extra_options = {})
    response = nil
    path = url(method, path, request_params)
    begin
      case method
      when 'get'
        response = self.get(path)
      when 'post'
        payload = build_query(payload) if request_params[:multipart] != true
        response = self.post(path, payload)
      end
    rescue RestClient::BadRequest => e
      raise BadRequest.new(JSON.parse(e.http_body)["statusMessage"])								
    rescue RestClient::ResourceNotFound => e
      raise ResourceNotFound.new(e.message)  
    rescue RestClient::Unauthorized => e
      raise UnAuthorizedException.new(e.message)
    rescue Exception => e
      raise e
    end

    unless extra_options[:stream] == true
      unless response.empty?
        response = ::ActiveSupport::JSON.decode(response)
        response = to_hashie(response)
      end
    end
    response
  end

  def get(path)
    RestClient::Request.execute(:method => :get, :url => path, :headers => @headers, :verify_ssl => false)
  end

  def post(path, data)
    RestClient::Request.execute(:method => :post, :url => path, :payload => data, :headers => @headers)
  end

  private
 
  def url(method, path, options = {})
    query_string = build_query(options)
    uri_hash = {:host => @host, :path => URI::encode(path), :query => query_string}
    uri = @protocol == 'http' ? URI::HTTP.build(uri_hash) : URI::HTTPS.build(uri_hash)
    uri.to_s
  end

  def escape_string(str)
    URI.escape(str, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end

  def encode_payload(options)
    return ::ActiveSupport::JSON.encode(options)
  end
  
  def build_query(options)
    return nil if options.nil? or options.empty?
    options = options.collect do |name, value|
      if value.is_a? Array
        value.collect { |v| "#{name}=#{v.class.to_s != 'Fixnum' ? escape_string(v.to_s) : v}" }.join('&')
      else
        "#{name}=#{!value.nil? ? (value.class.to_s != 'Fixnum' ? escape_string(value.to_s) : value) : ''}"
      end
    end.join('&')
    options
  end 
  
  def to_hashie json
    if json.is_a? Array
      json.collect! { |x| x.is_a?(Hash) ? Hashie::Mash.new(x) : x }
    else
      Hashie::Mash.new(json)
    end
  end
end