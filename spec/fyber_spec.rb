require 'rails_helper'
require 'rake'
require 'webmock/rspec'

describe 'fyber' do
  WebMock.disable_net_connect!(allow_localhost: true)
  it 'should make a call to offer api' do
    fyber = Fyber.new
    results = '{"information": {"appid": 157} }'

    expect(DateTime).to receive('now').and_return(DateTime.new(2015, 10, 10, 1, 1, 1).to_datetime)
    stub_request(:get, "http://api.sponsorpay.com/feed/v1/offers.json?appid=157&device_id=2b6f0cc904d137be2e1730235f5664094b83&format=json&hashkey=f50d9f619009c625cb720c2ffc4862ee865309e7&ip=109.235.143.113&locale=de&offer_types=112&timestamp=1444438861&uid=player1").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => results, :headers => {'X-Sponsorpay-Response-Signature': "af23d75634b3bd6dcb2293f31f73fb647405d5d8"})

    fyber_get_offers = fyber.get_offers('player1')
    expect(fyber_get_offers.response).to match_array(JSON.parse(results))
    expect(fyber_get_offers.errors).to be_nil
  end

  it "should reject response if the response signature is not matching" do
    fyber = Fyber.new
    results = '{"information": {"appid": 159} }'

    expect(DateTime).to receive('now').and_return(DateTime.new(2015, 10, 10, 1, 1, 1).to_datetime)
    stub_request(:get, "http://api.sponsorpay.com/feed/v1/offers.json?appid=157&device_id=2b6f0cc904d137be2e1730235f5664094b83&format=json&hashkey=f50d9f619009c625cb720c2ffc4862ee865309e7&ip=109.235.143.113&locale=de&offer_types=112&timestamp=1444438861&uid=player1").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => results, :headers => {'X-Sponsorpay-Response-Signature': "random"})

    fyber_get_offers = fyber.get_offers('player1')
    expect(fyber_get_offers.response).to match_array(JSON.parse("{}"))
    expect(fyber_get_offers.errors).to eq("Response Signature mismatch!")
  end

  it "add_signature should append API_KEY and SHA1" do
    fyber = Fyber.new
    signed_value = fyber.add_signature("api=123&test=456&")
    expect(signed_value).to eq("fe9cf82f51d920b31f0e2311c749f23aff87a167")
  end

  it "should order the parameters before signing" do
    fyber = Fyber.new
    expect(fyber.query_params({test: false, api_key: "some_api_key", nothing: 'ASLKJASD', int_value: 123})).
        to eq("api_key=some_api_key&int_value=123&nothing=ASLKJASD&test=false")
  end

  it "should ignore nil values while ordering the params" do
    fyber = Fyber.new
    expect(fyber.query_params({test: false, api_key: "some_api_key", nothing: 'ASLKJASD', int_value: 123, nil_param: nil})).
        to eq("api_key=some_api_key&int_value=123&nothing=ASLKJASD&test=false")
  end
end