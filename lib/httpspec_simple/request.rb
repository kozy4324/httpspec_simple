require 'net/http'
require 'uri'

module HttpspecSimple
  class Request
    def initialize(url)
      @url = URI.parse(url)
      @res = Net::HTTP.start(@url.host, @url.port) {|http|
        http.request(Net::HTTP::Get.new(@url.path))
      }
    end

    def status
      @res.code
    end

    def to_s
      @url.to_s
    end
  end
end
