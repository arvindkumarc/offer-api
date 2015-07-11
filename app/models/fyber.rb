require 'net/http'
require 'cgi'

class Fyber
  API_KEY = 'b07a12df7d52e6c118e5d47d3f9e60135b109a1f'
  APP_ID = 157

  def get_offers(uid, pub0 = nil, page = nil)
    params = {appid: APP_ID,
              uid: uid,
              format: 'json',
              pub0: pub0,
              page: page,
              device_id: '2b6f0cc904d137be2e1730235f5664094b83',
              locale: 'de',
              ip: '109.235.143.113',
              offer_types: 112,
              timestamp: DateTime.now.to_i}

    query_params = query_params(params)
    hash = add_signature(query_params+ '&')
    response = http_get('api.sponsorpay.com', '/feed/v1/offers.json', query_params.concat('&hashkey=').concat(hash))

    offers_response = JSON.parse(response.body)

    if offers_response['information']['appid'] == APP_ID && response.header['X-Sponsorpay-Response-Signature'] == add_signature(response.body)
      offers_response
    else
      JSON.parse("{}")
    end
  end

  def query_params(params)
    params.
        reject { |key, value| value.nil? }.
        sort.
        map { |key, value| "#{key}=#{value}" }.
        join('&')
  end

  def add_signature(params)
    Digest::SHA1.hexdigest(params + API_KEY)
  end

  def http_get(domain, path, params)
    Net::HTTP.get_response(domain, "#{path}?".concat(params))
  end
end