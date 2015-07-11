require 'rails_helper'
require 'rake'

describe 'fyber' do
  it 'should make a call to offer api' do
    fyber = Fyber.new
    results = %w(a b)

    expect(DateTime).to receive('now').and_return(DateTime.new(2015, 10, 10, 1, 1, 1).to_datetime)
    expect(Net::HTTP).to receive('get').with('api.sponsorpay.com', '/feed/v1/offers.json?appid=157&device_id=2b6f0cc904d137be2e1730235f5664094b83&format=json&ip=109.235.143.113&locale=de&offer_types=112&timestamp=1444438861&uid=player1&hashkey=f50d9f619009c625cb720c2ffc4862ee865309e7').and_return(results)

    expect(fyber.get_offers).to match_array(results)
  end

  it "add_signature should add API and SHA1" do
    fyber = Fyber.new
    signed_value = fyber.add_signature("api=123&test=456")
    expect(signed_value).to eq("api=123&test=456&hashkey=fe9cf82f51d920b31f0e2311c749f23aff87a167")
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