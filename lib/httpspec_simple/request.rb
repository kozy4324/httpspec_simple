require 'net/http'
require 'uri'

module HttpspecSimple
  class Request
    attr_reader :response_time, :status

    def initialize(url, opt = {})
      @url = URI.parse(url)
      http = Net::HTTP.new(@url.host, @url.port)
      unless opt[:timeout].nil?
        http.read_timeout = opt[:timeout]
        http.open_timeout = opt[:timeout]
      end
      retry_count = opt[:retry].to_i
      @status, @response_time = http.start do |http|
        res, response_time = process_time do
          open_timeout_error = if Net.const_defined?(:OpenTimeout) then Net::OpenTimeout else Timeout::Error end
          read_timeout_error = if Net.const_defined?(:ReadTimeout) then Net::ReadTimeout else Timeout::Error end
          begin
            res = http.request(Net::HTTP::Get.new(@url.path))
            raise RequestError.new if res.kind_of?(Net::HTTPClientError) or res.kind_of?(Net::HTTPServerError)
          rescue open_timeout_error, read_timeout_error, RequestError
            retry if (retry_count-=1) > 0
          end
          res
        end
        unless res.nil?
          [res.code, response_time]
        else
          ['timeout', response_time]
        end
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
  end

  class RequestError < StandardError; end
end
