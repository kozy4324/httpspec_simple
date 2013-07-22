require 'net/http'
require 'uri'

module HttpspecSimple
  class Request
    attr_reader :response_time

    def initialize(url)
      @url = URI.parse(url)
      response_time = nil
      @res, @response_time = Net::HTTP.start(@url.host, @url.port) {|http|
        process_time do
          http.request(Net::HTTP::Get.new(@url.path))
        end
      }
    end

    def process_time
      start_time = Time.now
      ret = yield
      [ret, Time.now - start_time]
    end

    def status
      @res.code
    end

    def to_s
      @url.to_s
    end
  end
end
