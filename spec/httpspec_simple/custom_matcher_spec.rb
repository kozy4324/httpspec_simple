require 'spec_helper'

describe 'custom matchers' do
  describe '#be_http_ok' do
    it "should check status code" do
      response = nil
      server_start { response = request('/', :immediately => true) }
      expect {
        response.should be_http_ok
      }.not_to raise_error
    end
  end

  describe '#be_http_redirect' do
    it "should check status code 301" do
      _, response = server_start('/' => Proc.new {|req, res|
        res.status = '301'
      }) do
        response = request('/', :immediately => true)
      end
      expect {
        response.should be_http_redirect
      }.not_to raise_error
    end
    it "should check status code 302" do
      _, response = server_start('/' => Proc.new {|req, res|
        res.status = '302'
      }) do
        response = request('/', :immediately => true)
      end
      expect {
        response.should be_http_redirect
      }.not_to raise_error
    end
  end

  describe '#be_http_redirect_30(1|2)_to' do
    it "should check status code 301 with Location header" do
      _, response = server_start('/' => Proc.new {|req, res|
        res.status = '301'
        res['Location'] = 'http://example.com/hoge'
      }) do
        response = request('/', :immediately => true)
      end
      expect {
        response.should be_http_redirect_301_to 'http://example.com/hoge'
      }.not_to raise_error
    end
    it "should check status code 302 with Location header" do
      _, response = server_start('/' => Proc.new {|req, res|
        res.status = '302'
        res['Location'] = 'http://example.com/foo'
      }) do
        response = request('/', :immediately => true)
      end
      expect {
        response.should be_http_redirect_302_to 'http://example.com/foo'
      }.not_to raise_error
    end
  end

  describe '#respond_within(num).seconds' do
    it "should check response time" do
      requests, response = server_start('/' => Proc.new {|req, res| sleep 2 }) do
        request('/', :immediately => true)
      end
      response.should respond_within(3).seconds
      expect {
        response.should respond_within(1).seconds
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

  describe '#retrieve_body_including(string)' do
    it "should check response body" do
      requests, response = server_start('/' => Proc.new {|req, res| res.body = "<div>body string</div>" }) do
        request('/', :immediately => true)
      end
      response.should retrieve_body_including 'dy st'
    end
  end

  describe '#retrieve_body_matching(regexp)' do
    it "should check response body" do
      requests, response = server_start('/' => Proc.new {|req, res| res.body = "<div>body string</div>" }) do
        request('/', :immediately => true)
      end
      response.should retrieve_body_matching %r|<div>(.+?)</div>|
    end
  end
end
