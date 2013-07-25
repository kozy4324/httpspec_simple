require 'net/http'
require 'uri'

module HttpspecSimple
  class Request
    attr_reader :response_time, :status, :body

    def initialize(url, opt = {})
      @url = URI.parse(url)
      http = Net::HTTP.new(@url.host, @url.port)
      http.open_timeout = opt[:timeout] || Request.configuration.timeout
      http.read_timeout = opt[:timeout] || Request.configuration.timeout
      retry_count = (opt[:retry] || Request.configuration.retry).to_i
      res, @response_time = process_time do
        http.start do |http|
          open_timeout_error = if Net.const_defined?(:OpenTimeout) then Net::OpenTimeout else Timeout::Error end
          read_timeout_error = if Net.const_defined?(:ReadTimeout) then Net::ReadTimeout else Timeout::Error end
          begin
            req = Net::HTTP::Get.new(@url.path)
            if (headers = opt[:headers] || Request.configuration.headers)
              headers.each {|k, v| req[k] = v }
            end
            res = http.request(req)
            raise RequestError.new if res.kind_of?(Net::HTTPClientError) or res.kind_of?(Net::HTTPServerError)
          rescue open_timeout_error, read_timeout_error, RequestError
            retry if (retry_count-=1) > 0
          end
          res
        end
      end
      @status = res ? res.code : 'timeout'
      unless res.nil?
        @body = res.body
        charset = (res['content-type'] || '').split(';').select{|i| i.start_with?('charset=')}.map{|i| i.sub('charset=', '')}[0]
        @body.force_encoding(charset) unless charset.nil?
      end
    end

    def process_time
      start_time = Time.now
      ret = yield
      [ret, Time.now - start_time]
    end

    def to_s
      @url.to_s
    end

    class << Request
      def configure
        config = CONFIG_CLASS.new(20, 0)
        yield config if block_given?
        configuration.timeout = config.timeout
        configuration.retry = config.retry
        configuration.headers = config.headers
      end

      CONFIG_CLASS = Struct.new(:timeout, :retry, :headers)

      def configuration
        @config ||= reset_configuration
      end

      def reset_configuration
        @config = CONFIG_CLASS.new(20, 0, {})
      end
    end
  end

  class RequestError < StandardError; end

  class RequestContainer
    def self.subclass(url, opt = {})
      sub = Class.new(self) do
        def to_s; self.class.to_s; end
        def response_time; self.class.response_time; end
        def status; self.class.status; end
        def body; self.class.body; end
      end
      class << sub
        def url=(_url); @url = _url; end
        def opt=(_opt); @opt = _opt; end
        def request; @request ||= Request.new(@url, @opt); end
        def to_s; request.to_s; end
        def response_time; request.response_time; end
        def status; request.status; end
        def body; request.body; end
      end
      sub.url = url
      sub.opt = opt
      sub.status if opt[:immediately]
      sub
    end
  end
end
