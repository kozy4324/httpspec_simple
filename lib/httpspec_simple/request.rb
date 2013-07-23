require 'net/http'
require 'uri'

# TODO: retry

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
      @status, @response_time = http.start do |http|
        res, response_time = process_time do
          begin
            http.request(Net::HTTP::Get.new(@url.path))
          rescue Net::OpenTimeout, Net::ReadTimeout
          end
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
end
